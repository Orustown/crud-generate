<#assign facadeFullName = entity?substring(0,1)?lower_case + entity?substring(1) + cfg.custom_facadeClass>
<#assign tmpEntityLowerCase = entity?substring(0,1)?lower_case + entity?substring(1)>

import org.springframework.web.bind.annotation.RequestMapping;
<#if restControllerStyle>
import org.springframework.web.bind.annotation.RestController;
<#else>
import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
</#if>
<#if swagger2>
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
</#if>
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import javax.validation.constraints.NotEmpty;
import java.util.List;
import javax.validation.Valid;

@Validated
<#if swagger2>
@Api(tags = "${table.comment}")
</#if>
<#if restControllerStyle>
@RestController
<#else>
@Controller
</#if>
<#--@RequestMapping("<#if package.ModuleName?? && package.ModuleName != "">/${package.ModuleName}</#if>/<#if controllerMappingHyphenStyle??>${controllerMappingHyphen}<#else>${table.entityPath}</#if>")-->
@RequestMapping("<#if package.ModuleName?? && package.ModuleName != "">${package.ModuleName}</#if>/${table.entityPath}")
<#if kotlin>
class ${table.controllerName}<#if superControllerClass??> : ${superControllerClass}()</#if>
<#else>
    <#if superControllerClass??>
public class ${table.controllerName} extends ${superControllerClass} {
    <#else>
public class ${table.controllerName} {
    </#if>
    @Autowired
    private ${entity}${cfg.custom_facadeClass} ${facadeFullName};

    @ApiOperation("新增")
    @PostMapping("add")
    public void add(@RequestBody @Valid ${entity}AddBO ${tmpEntityLowerCase}AddBO) {
        ${facadeFullName}.add(${tmpEntityLowerCase}AddBO);
    }

    @ApiOperation("编辑")
    @PostMapping("edit")
    public void edit(@RequestBody @Valid ${entity}EditBO ${tmpEntityLowerCase}EditBO) {
        ${facadeFullName}.edit(${tmpEntityLowerCase}EditBO);
    }

    @ApiOperation("分页查询")
    @GetMapping("page")
    public ${cfg.custom_commonPageVOClass}<${entity}VO> page(${entity}PageBO ${tmpEntityLowerCase}PageBO) {
        return ${facadeFullName}.page(${tmpEntityLowerCase}PageBO);
    }

    @ApiOperation("删除")
    @PostMapping("delete")
    public void delete(@RequestBody @Valid @NotEmpty List<Long> idList) {
        ${facadeFullName}.delete(idList);
    }
}
</#if>
