/***************************************************************************
                          qgsactionmanager.sip

 These classes store and control the management and execution of actions
 associated with a particular Qgis layer. Actions are defined to be
 external programs that are run with user-specified inputs that can
 depend on the contents of layer attributes.

                             -------------------
    begin                : Oct 24 2004
    copyright            : (C) 2004 by Gavin Macaulay
    email                : gavin at macaulay dot co dot nz
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** \class QgsActionManager
 * \brief Storage and management of actions associated with Qgis layer
 * attributes.
 */

class QgsActionManager
{
%TypeHeaderCode
#include <qgsactionmanager.h>
%End
  public:
    //! Constructor
    QgsActionManager( QgsVectorLayer *layer );

    //! Destructor
    virtual ~QgsActionManager();

    /** Add an action with the given name and action details.
     * Will happily have duplicate names and actions. If
     * capture is true, when running the action using doAction(),
     * any stdout from the process will be captured and displayed in a
     * dialog box.
     */
    QUuid addAction(QgsAction::ActionType type, const QString& name, const QString& command, bool capture = false );

    /** Add an action with the given name and action details.
     * Will happily have duplicate names and actions. If
     * capture is true, when running the action using doAction(),
     * any stdout from the process will be captured and displayed in a
     * dialog box.
     */
    QUuid addAction(QgsAction::ActionType type, const QString& name, const QString& command, const QString& icon, bool capture = false );

    /**
     * Add a new action to this list.
     */
    void addAction( const QgsAction& action );

    /**
     * Remove an action by its id.
     *
     * @note Added in QGIS 3.0
     */
    void removeAction( const QUuid& actionId );

    /** Does the given values. defaultValueIndex is the index of the
     *  field to be used if the action has a $currfield placeholder.
     *  @note available in python bindings as doActionFeature
     */
    void doAction(const QUuid& actionId, const QgsFeature& feature, int defaultValueIndex = 0 ) /PyName=doActionFeature/;

    /** Does the action using the expression engine to replace any embedded expressions
     * in the action definition.
     * @param actionId action id
     * @param feature feature to run action for
     * @param context expression context to evaluate expressions under
     */
    void doAction( const QUuid& actionId, const QgsFeature& feature, const QgsExpressionContext& context );

    //! Removes all actions
    void clearActions();

    /**
     * Return a list of actions that are available in the given action scope.
     * If no action scope is provided, all actions will be returned.
     */
    QList<QgsAction> actions( const QString& actionScope = QString() ) const;

    //! Return the layer
    QgsVectorLayer* layer() const;

    //! Writes the actions out in XML format
    bool writeXml( QDomNode& layer_node ) const;

    //! Reads the actions in in XML format
    bool readXml( const QDomNode& layer_node );

    /**
     * Get an action by its id.
     *
     * @note Added in QGIS 3.0
     */
    QgsAction action( const QUuid& id );

    /**
     * Each scope can have a default action. This will be saved in the project
     * file.
     *
     * @note Added in QGIS 3.0
     */
    void setDefaultAction( const QString& actionScope, const QUuid& actionId );

    /**
     * Each scope can have a default action. This will be saved in the project
     * file.
     *
     * @note Added in QGIS 3.0
     */
    QgsAction defaultAction( const QString& actionScope );

};
