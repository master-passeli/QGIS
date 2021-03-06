/** \ingroup gui
 * \class QgsHelp
 * @brief Helper class for showing help topic URI for the given key.
 *
 * Help can be stored online, on the local directory or on the intranet
 * server. Location of the QGIS help can be configured in QGIS options.
 * Multiple locations are supported, they will be used in order of
 * preference, from top to bottom.
 *
 * URI construction takes in account following information:
 *  - QGIS version
 *  - language of the QGIS UI
 *
 * If no help found, default error page with information how to setup
 * help system will be shown.
 *
 * @note added in QGIS 3.0
 */
class QgsHelp
{
%TypeHeaderCode
#include <qgshelp.h>
%End

  public:

    /** Opens help topic for the given help key using default system
     * web browser. If help topic not found, builtin error page shown.
     * @param key key which identified help topic
     * @note added in QGIS 3.0
     */
    static void openHelp( const QString& key );

    /** Returns URI of the help topic for the given key. If help topic
     * not found, URI of the builtin error page returned.
     * @param key key which identified help topic
     * @note added in QGIS 3.0
     */
    static QUrl helpUrl( const QString& key );
};
