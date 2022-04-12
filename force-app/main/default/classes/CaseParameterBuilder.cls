public with sharing class CaseParameterBuilder {
    private List<String> paramsList;

    public CaseParameterBuilder() {
        this.paramsList = new List<String>();
    }

    public CaseParameterBuilder addParam(String paramName, String paramValue) {
        String result = this.paramsList.isEmpty() ? '?' : '';
        result += constructParameterForEndpoint(paramName, paramValue);
        this.paramsList.add(result);
        return this;
    }

    private String constructParameterForEndpoint(String paramName, String paramValue) {
        return String.join(new List <String>{
                paramName, paramValue
        }, '=');
    }

    public String build() {
        return String.join(this.paramsList, '&');
    }
}