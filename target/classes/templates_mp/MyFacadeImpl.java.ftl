<#assign tmpEntityLowerCase = entity?substring(0,1)?lower_case + entity?substring(1)>
<#assign tmpServiceFullName = table.serviceName?substring(0,1)?lower_case + table.serviceName?substring(1)>
<#if cfg.custom_pageBOCreateTimeStartField??>
    <#assign tmpUpperCasePageBOCreateTimeStartField = cfg.custom_pageBOCreateTimeStartField?substring(0,1)?upper_case + cfg.custom_pageBOCreateTimeStartField?substring(1)>
</#if>
<#if cfg.custom_pageBOCreateTimeEndField??>
    <#assign tmpUpperCasePageBOCreateTimeEndField = cfg.custom_pageBOCreateTimeEndField?substring(0,1)?upper_case + cfg.custom_pageBOCreateTimeEndField?substring(1)>
</#if>
<#if cfg.custom_superEntityCreateTimeField??>
    <#assign tmpSuperEntityCreateTimeField = cfg.custom_superEntityCreateTimeField?substring(0,1)?upper_case + cfg.custom_superEntityCreateTimeField?substring(1)>
</#if>
<#if cfg.custom_facadeImplImportClassList??>
<#list cfg.custom_facadeImplImportClassList as pkg>
import ${pkg};
</#list>
</#if>
<#if cfg.custom_commonPageVOClass?has_content>
    <#assign parts = cfg.custom_commonPageVOClass?split(".")>
    <#assign tmpCommonPageVOClass = parts[parts?size - 1]>
import ${cfg.custom_commonPageVOClass};
</#if>

import ${superServiceImplClassPackage};
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.util.StringUtils;
import java.util.List;

@Component
<#if kotlin>
open class ${entity}${cfg.custom_facadeImplClass} : ${entity}${cfg.custom_facadeClass} {

}
<#else>
public class ${entity}${cfg.custom_facadeImplClass} implements ${entity}${cfg.custom_facadeClass} {

    @Autowired
    private ${table.serviceName} ${tmpServiceFullName};

    @Override
    public void add(${entity}AddBO ${tmpEntityLowerCase}AddBO) {
        ${entity} ${tmpEntityLowerCase} = BeanUtil.copy(${tmpEntityLowerCase}AddBO, ${entity}.class);
        ${tmpServiceFullName}.save(${tmpEntityLowerCase});
    }

    @Override
    public void edit(${entity}EditBO ${tmpEntityLowerCase}EditBO) {
        ${entity} ${tmpEntityLowerCase} = BeanUtil.copy(${tmpEntityLowerCase}EditBO, ${entity}.class);
        ${tmpServiceFullName}.updateById(${tmpEntityLowerCase});
    }

    @Override
    public ${tmpCommonPageVOClass}<${entity}VO> page(${entity}PageBO ${tmpEntityLowerCase}PageBO) {
        Page<${entity}> page = PageUtil.toPage(${tmpEntityLowerCase}PageBO);
        Page<${entity}> pageResult = ${tmpServiceFullName}.lambdaQuery()
<#list table.fields as field>
    <#if field.keyFlag>
    <#-- 主键（分页时用不到主键） -->
    <#-- 普通字段 -->
    <#else>
        <#assign tmpFieldNameUpperCase = field.propertyName?substring(0,1)?upper_case + field.propertyName?substring(1)>
        <#if field.propertyType == "String">
                .like(StringUtils.hasText(${tmpEntityLowerCase}PageBO.get${tmpFieldNameUpperCase}()),
                        ${entity}::get${tmpFieldNameUpperCase}, ${tmpEntityLowerCase}PageBO.get${tmpFieldNameUpperCase}())
        <#else>
                .eq(${tmpEntityLowerCase}PageBO.get${tmpFieldNameUpperCase}() != null,
                        ${entity}::get${tmpFieldNameUpperCase}, ${tmpEntityLowerCase}PageBO.get${tmpFieldNameUpperCase}())
        </#if>
    </#if>
</#list>
        <#if tmpUpperCasePageBOCreateTimeStartField?? && superEntityClass?? && tmpSuperEntityCreateTimeField??>
                .ge(${tmpEntityLowerCase}PageBO.get${tmpUpperCasePageBOCreateTimeStartField}() != null,
                        ${superEntityClass}::get${tmpSuperEntityCreateTimeField}, ${tmpEntityLowerCase}PageBO.get${tmpUpperCasePageBOCreateTimeStartField}())
        <#else>
        </#if>
        <#if tmpUpperCasePageBOCreateTimeEndField?? && superEntityClass?? && tmpSuperEntityCreateTimeField??>
                .lt(${tmpEntityLowerCase}PageBO.get${tmpUpperCasePageBOCreateTimeEndField}() != null,
                        ${superEntityClass}::get${tmpSuperEntityCreateTimeField}, ${tmpEntityLowerCase}PageBO.get${tmpUpperCasePageBOCreateTimeEndField}())
        <#else>
        </#if>
        <#if superEntityClass?? && tmpSuperEntityCreateTimeField??>
                .orderByDesc(${superEntityClass}::get${tmpSuperEntityCreateTimeField})
        <#else>
        </#if>
                .page(page);

        return PageUtil.toPageVO(pageResult, ${entity}VO.class);
    }

    @Override
    public void delete(List<Long> idList) {
        ${tmpServiceFullName}.removeBatchByIds(idList);
    }
}
</#if>