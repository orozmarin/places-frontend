class ServicesUriHelper {
  static String getUrlWithParams(String template, Map<String, dynamic> params) {
    params.forEach((String key, dynamic value) {
      template = template.replaceAll("{" + key + "}", value);
    });
    return template;
  }
}
