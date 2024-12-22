
<#list table.importPackages as pkg>
import ${pkg};
</#list>
<#if swagger2>
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
</#if>
<#if entityLombokModel>
import lombok.Data;
    <#if chainModel>
import lombok.experimental.Accessors;
    </#if>
</#if>
<#if cfg.custom_commonPageBOClass?has_content>
import lombok.EqualsAndHashCode;
</#if>

<#if cfg.custom_commonPageBOClass?has_content>
    <#assign parts = cfg.custom_commonPageBOClass?split(".")>
    <#assign tmpCommonPageBOClass = parts[parts?size - 1]>
import ${cfg.custom_commonPageBOClass};
</#if>

<#if entityLombokModel>
@Data
    <#if chainModel>
@Accessors(chain = true)
    </#if>
</#if>
<#if swagger2>
@ApiModel(value="${table.comment}分页请求对象")
</#if>
<#if cfg.custom_commonPageBOClass?has_content>
@EqualsAndHashCode(callSuper = true)
public class ${entity}PageBO extends ${tmpCommonPageBOClass} {
<#else >
public class ${entity}PageBO {
</#if>
<#-- ----------  BEGIN 字段循环遍历  ---------->
<#list table.fields as field>
    <#if field.keyFlag>
    <#-- 主键（新建时用不到主键） -->
    <#-- 普通字段 -->
    <#else>
        <#if field.comment?has_content>
            <#if swagger2>
    @ApiModelProperty("${field.comment}")
            </#if>
        </#if>
    private ${field.propertyType} ${field.propertyName};
    </#if>

</#list>
<#------------  END 字段循环遍历  ---------->
<#if !entityLombokModel>
    <#list table.fields as field>
        <#if field.propertyType == "boolean">
            <#assign getprefix="is"/>
        <#else>
            <#assign getprefix="get"/>
        </#if>
    public ${field.propertyType} ${getprefix}${field.capitalName}() {
        return ${field.propertyName};
    }
        <#if chainModel>
    public ${entity} set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
        <#else>
    public void set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
        </#if>
        this.${field.propertyName} = ${field.propertyName};
        <#if chainModel>
            return this;
        </#if>
    }
    </#list>
</#if>
<#if entityColumnConstant>
    <#list table.fields as field>
     public static final String ${field.name?upper_case} = "${field.name}";

    </#list>
</#if>
<#if activeRecord>
    @Override
    protected Serializable pkVal() {
    <#if keyPropertyName??>
        return this.${keyPropertyName};
    <#else>
        return null;
    </#if>
    }
</#if>
<#if !entityLombokModel>
    @Override
    public String toString() {
    return "${entity}{" +
    <#list table.fields as field>
        <#if field_index==0>
            "${field.propertyName}=" + ${field.propertyName} +
        <#else>
            ", ${field.propertyName}=" + ${field.propertyName} +
        </#if>
    </#list>
    "}";
    }
</#if>
}