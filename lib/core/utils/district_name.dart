import '../../l10n/app_localizations.dart';

/// Localised display name for a coverage district. District names arrive from
/// the GETRA registry in English; this maps the stable id to a translated name,
/// falling back to the registry name for any id we do not have a translation for.
String localizedDistrictName(AppLocalizations l, String id, String fallback) {
  switch (id) {
    case 'galle':
      return l.districtGalle;
    case 'matara':
      return l.districtMatara;
    case 'tangalle':
      return l.districtTangalle;
    default:
      return fallback;
  }
}
