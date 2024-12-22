<#assign tmpEntityLowerCase = entity?substring(0,1)?lower_case + entity?substring(1)>

import ${superServiceClassPackage};

<#if cfg.custom_commonPageVOClass?has_content>
    <#assign parts = cfg.custom_commonPageVOClass?split(".")>
    <#assign tmpCommonPageVOClass = parts[parts?size - 1]>
import ${cfg.custom_commonPageVOClass};
</#if>
import java.util.List;

<#if kotlin>
interface ${entity}${cfg.custom_facadeClass}
<#else>
public interface ${entity}${cfg.custom_facadeClass} {
    void add(${entity}AddBO ${tmpEntityLowerCase}AddBO);

    void edit(${entity}EditBO ${tmpEntityLowerCase}EditBO);

    ${tmpCommonPageVOClass}<${entity}VO> page(${entity}PageBO ${tmpEntityLowerCase}PageBO);

    void delete(List<Long> idList);
}
</#if>