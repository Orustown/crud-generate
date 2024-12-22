package com.example.generate;

import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.*;
import com.baomidou.mybatisplus.generator.config.builder.ConfigBuilder;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.querys.MySqlQuery;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.util.*;

public class Generate {
    private static final String URL = "jdbc:mysql://" +
            "127.0.0.1:3306/demo" +
            "?useUnicode=true&characterEncoding=utf8" +
            "&allowPublicKeyRetrieval=True&useSSL=false" +
            "&serverTimezone=Asia/Shanghai";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "123456";

    // 支持多个
    //   可以用这些符号隔开：英文逗号、回车、tab、空格
    //   可以用SQL列出所有表，将结果直接复制过来。SQL是：SHOW TABLES
    private static final String TABLE_NAME = "tb_app";
    private static final String TABLE_PREFIX = "tb_";

    // entity公共父类及其列名。如果没有，置为null即可
    private static final String SUPER_ENTITY_CLASS =
            "com.suchtool.nicecommon.core.entity.CommonEntity";
    private static final String[] SUPER_ENTITY_COLUMNS = new String[]{
            "id", "create_time", "update_time", "delete_flag",
            "create_id", "create_name", "update_id", "update_name"
//            "id", "gmt_create", "gmt_modify",

    };

    // 公共的BO、VO等。如果没有，置为null即可
    private static final String COMMON_VO_CLASS = "com.suchtool.nicecommon.core.entity.CommonVO";
    private static final String COMMON_PAGE_BO_CLASS = "com.suchtool.nicecommon.core.entity.PageBO";
    private static final String COMMON_PAGE_VO_CLASS = "com.suchtool.nicecommon.core.entity.PageVO";

    // facadeImpl里要导入的包。如果没有，把列表成员删掉即可
    private static final List<String> FACADE_IMPL_IMPORT_CLASS_LIST = Arrays.asList(
            "com.suchtool.nicetool.util.base.BeanUtil",
            "com.suchtool.nicecommon.core.util.PageUtil",
            "com.suchtool.nicecommon.core.entity.CommonEntity"
    );

    // 分页入参里的创建时间开始和创建时间结束。若没有，置为null即可。
    private static final String PAGE_BO_CREATE_TIME_START_FIELD = "createTimeStart";
    private static final String PAGE_BO_CREATE_TIME_END_FIELD = "createTimeEnd";

    // entity公共父类里的创建时间字段，用于分页时的排序。若没有，置为null即可。
    private static final String SUPER_ENTITY_CREATE_TIME_FIELD = "createTime";

    // 模板文件的位置
    private static final String TEMPLATE_PATH = "templates_mp/";

    public static void main(String[] args) {
        String[] parts = TABLE_NAME.split("[,\n\t\\s]+");

        // 输出分割后的字符串数组
        for (String part : parts) {
            execute(part);
        }
    }

    private static void execute(String tableName) {
        // 代码生成器
        AutoGenerator autoGenerator = new AutoGenerator();

        // 全局配置
        GlobalConfig globalConfig = buildGlobalConfig();
        autoGenerator.setGlobalConfig(globalConfig);

        // 数据源配置
        DataSourceConfig dataSourceConfig = buildDataSourceConfig();
        autoGenerator.setDataSource(dataSourceConfig);

        // 包配置
        PackageConfig packageConfig = buildPackageConfig(tableName);
        autoGenerator.setPackageInfo(packageConfig);

        // 配置自定义输出模板
        TemplateConfig templateConfig = buildTemplateConfig();
        autoGenerator.setTemplate(templateConfig);

        // 策略配置
        StrategyConfig strategyConfig = buildStrategyConfig(tableName);
        autoGenerator.setStrategy(strategyConfig);

        // 生成自定义的文件（BO、VO、Facade等）
        InjectionConfig injectionConfig = buildInjectionConfig(
                globalConfig.getOutputDir(), packageConfig.getParent());
        autoGenerator.setCfg(injectionConfig);

        autoGenerator.setTemplateEngine(new FreemarkerTemplateEngine());
        autoGenerator.execute();
    }

    private static GlobalConfig buildGlobalConfig() {
        GlobalConfig globalConfig = new GlobalConfig();
        String projectPath = System.getProperty("user.dir");
        globalConfig.setOutputDir(projectPath + "/src/main/java");
        globalConfig.setAuthor("作者");
        globalConfig.setFileOverride(false);  //默认就是false
        globalConfig.setOpen(false);
        // globalConfig.setBaseResultMap(true); // mapper.xml 生成 ResultMap
        // globalConfig.setBaseColumnList(true); // mapper.xml 生成 ColumnList
        // 自定义文件命名，注意 %s 会自动填充表实体属性！
        globalConfig.setMapperName("%sMapper");
        // globalConfig.setXmlName("%sDao");
        globalConfig.setServiceName("%sService");
        globalConfig.setServiceImplName("%sServiceImpl");
        globalConfig.setControllerName("%sController");
        globalConfig.setSwagger2(true);

        return globalConfig;
    }

    private static DataSourceConfig buildDataSourceConfig() {
        DataSourceConfig dataSourceConfig = new DataSourceConfig();
        dataSourceConfig.setUrl(URL);
        // dsc.setSchemaName("public");
        dataSourceConfig.setDriverName("com.mysql.cj.jdbc.Driver");
        dataSourceConfig.setUsername(USERNAME);
        dataSourceConfig.setPassword(PASSWORD);
        dataSourceConfig.setDbQuery(new MySqlQuery() {
            /**
             * 查询自定义字段（这里查询的 SQL 对应父类 tableFieldsSql 的查询字段，若不能满足需求请重写它
             * 模板中调用：  table.fields 获取所有字段信息，
             * 然后循环字段获取 field.customMap 从 MAP 中获取注入字段如下  NULL 或者 PRIVILEGES
             *
             * 对应的字段名是SQL执行结果：SHOW FULL FIELDS FROM t_user;
             */
            @Override
            public String[] fieldCustom() {
                return new String[]{"NULL", "PRIVILEGES"};
            }
        });

        return dataSourceConfig;
    }

    private static PackageConfig buildPackageConfig(String tableName) {
        String parentPackage = "com.example.generate." +
                tableName.substring(TABLE_PREFIX.length()).replace("_", "");
        PackageConfig packageConfig = new PackageConfig();
        // packageConfig.setParent("com.example.generate.out");
        // packageConfig.setModuleName("xxx");
        packageConfig.setParent(parentPackage);

        return packageConfig;
    }

    private static TemplateConfig buildTemplateConfig() {
        TemplateConfig templateConfig = new TemplateConfig();
        //指定自定义模板路径，注意不要带上.ftl/.vm, 会根据使用的模板引擎自动识别
        templateConfig.setController(TEMPLATE_PATH + "MyController.java");
        templateConfig.setService(TEMPLATE_PATH + "MyService.java");
        templateConfig.setServiceImpl(TEMPLATE_PATH + "MyServiceImpl.java");
        templateConfig.setMapper(TEMPLATE_PATH + "MyMapper.java");
        templateConfig.setEntity(TEMPLATE_PATH + "MyEntity.java");
        templateConfig.setXml(null);

        return templateConfig;
    }

    private static StrategyConfig buildStrategyConfig(String tableName) {
        StrategyConfig strategyConfig = new StrategyConfig();
        strategyConfig.setNaming(NamingStrategy.underline_to_camel);
        strategyConfig.setColumnNaming(NamingStrategy.underline_to_camel);
        strategyConfig.setEntityLombokModel(true);
        strategyConfig.setChainModel(false);
        strategyConfig.setRestControllerStyle(true);
        // 公共父类
        // strategyConfig.setSuperControllerClass("你自己的父类控制器,没有就不用设置!");
        // Entity父类
        strategyConfig.setSuperEntityClass(SUPER_ENTITY_CLASS);
        // 写于Entity父类中的公共字段
        strategyConfig.setSuperEntityColumns(SUPER_ENTITY_COLUMNS);
        // 表名
        strategyConfig.setInclude(tableName);
        strategyConfig.setTablePrefix(TABLE_PREFIX);
        strategyConfig.setControllerMappingHyphenStyle(true);

        return strategyConfig;
    }

    private static InjectionConfig buildInjectionConfig(String outputDir,
                                                        String parentPackage) {
        String fileDir = outputDir + "/" + parentPackage.replace(".", "/");

        InjectionConfig injectionConfig = new InjectionConfig() {
            //在.ftl(或者.vm)模板中，通过${cfg.xxx}获取属性
            @Override
            public void initMap() {
                ConfigBuilder config = this.getConfig();

                Map<String, Object> map = new HashMap<>();
                // 模板中获取值：${cfg.abc}
                // map.put("abc", config.getGlobalConfig().getAuthor() + "-mp");
                map.put("custom_commonVOClass", COMMON_VO_CLASS);
                map.put("custom_commonPageBOClass", COMMON_PAGE_BO_CLASS);
                map.put("custom_commonPageVOClass", COMMON_PAGE_VO_CLASS);
                map.put("custom_pageBOCreateTimeStartField", PAGE_BO_CREATE_TIME_START_FIELD);
                map.put("custom_pageBOCreateTimeEndField", PAGE_BO_CREATE_TIME_END_FIELD);
                map.put("custom_superEntityCreateTimeField", SUPER_ENTITY_CREATE_TIME_FIELD);
                map.put("custom_facadeClass", "Facade");
                map.put("custom_facadeImplClass", "FacadeImpl");
                map.put("custom_facadeImplImportClassList", FACADE_IMPL_IMPORT_CLASS_LIST);

                this.setMap(map);
            }
        };
        List<FileOutConfig> fileOutConfigList = new ArrayList<>();
        //生成AddBO
        fileOutConfigList.add(new FileOutConfig(TEMPLATE_PATH + "MyAddBO.java.ftl") {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return fileDir + "/bo/" + tableInfo.getEntityName() + "AddBO.java";
            }
        });
        //生成EditBO
        fileOutConfigList.add(new FileOutConfig(TEMPLATE_PATH + "MyEditBO.java.ftl") {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return fileDir + "/bo/" + tableInfo.getEntityName() + "EditBO.java";
            }
        });
        //生成VO
        fileOutConfigList.add(new FileOutConfig(TEMPLATE_PATH + "MyVO.java.ftl") {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return fileDir + "/vo/" + tableInfo.getEntityName() + "VO.java";
            }
        });
        //生成PageBO
        fileOutConfigList.add(new FileOutConfig(TEMPLATE_PATH + "MyPageBO.java.ftl") {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return fileDir + "/bo/" + tableInfo.getEntityName() + "PageBO.java";
            }
        });

        //生成Facade
        fileOutConfigList.add(new FileOutConfig(TEMPLATE_PATH + "MyFacade.java.ftl") {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return fileDir + "/facade/" + tableInfo.getEntityName() + "Facade.java";
            }
        });
        //生成FacadeImpl
        fileOutConfigList.add(new FileOutConfig(TEMPLATE_PATH + "MyFacadeImpl.java.ftl") {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return fileDir + "/facade/impl/" + tableInfo.getEntityName() + "FacadeImpl.java";
            }
        });

        injectionConfig.setFileOutConfigList(fileOutConfigList);

        return injectionConfig;
    }
}
