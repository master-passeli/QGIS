# -*- coding: utf-8 -*-

"""
***************************************************************************
    Difference.py
    ---------------------
    Date                 : August 2012
    Copyright            : (C) 2012 by Victor Olaya
    Email                : volayaf at gmail dot com
***************************************************************************
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
***************************************************************************
"""

__author__ = 'Victor Olaya'
__date__ = 'August 2012'
__copyright__ = '(C) 2012, Victor Olaya'

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = '$Format:%H$'

import os

from qgis.PyQt.QtGui import QIcon

from qgis.core import QgsFeatureRequest, QgsFeature, QgsGeometry, QgsWkbTypes
from processing.core.ProcessingLog import ProcessingLog
from processing.core.GeoAlgorithm import GeoAlgorithm
from processing.core.parameters import ParameterVector
from processing.core.outputs import OutputVector
from processing.tools import dataobjects, vector

pluginPath = os.path.split(os.path.split(os.path.dirname(__file__))[0])[0]


class Difference(GeoAlgorithm):

    INPUT = 'INPUT'
    OVERLAY = 'OVERLAY'
    IGNORE_INVALID = 'IGNORE_INVALID'
    OUTPUT = 'OUTPUT'

    def getIcon(self):
        return QIcon(os.path.join(pluginPath, 'images', 'ftools', 'difference.png'))

    def defineCharacteristics(self):
        self.name, self.i18n_name = self.trAlgorithm('Difference')
        self.group, self.i18n_group = self.trAlgorithm('Vector overlay tools')
        self.addParameter(ParameterVector(Difference.INPUT,
                                          self.tr('Input layer')))
        self.addParameter(ParameterVector(Difference.OVERLAY,
                                          self.tr('Difference layer')))
        self.addOutput(OutputVector(Difference.OUTPUT, self.tr('Difference')))

    def processAlgorithm(self, feedback):
        layerA = dataobjects.getObjectFromUri(
            self.getParameterValue(Difference.INPUT))
        layerB = dataobjects.getObjectFromUri(
            self.getParameterValue(Difference.OVERLAY))

        geomType = QgsWkbTypes.multiType(layerA.wkbType())
        writer = self.getOutputFromName(
            Difference.OUTPUT).getVectorWriter(layerA.fields(),
                                               geomType,
                                               layerA.crs())

        outFeat = QgsFeature()
        index = vector.spatialindex(layerB)
        selectionA = vector.features(layerA)
        total = 100.0 / len(selectionA)
        for current, inFeatA in enumerate(selectionA):
            geom = inFeatA.geometry()
            diff_geom = QgsGeometry(geom)
            attrs = inFeatA.attributes()
            intersections = index.intersects(geom.boundingBox())

            request = QgsFeatureRequest().setFilterFids(intersections).setSubsetOfAttributes([])
            for inFeatB in layerB.getFeatures(request):
                tmpGeom = inFeatB.geometry()
                if diff_geom.intersects(tmpGeom):
                    diff_geom = QgsGeometry(diff_geom.difference(tmpGeom))

            try:
                outFeat.setGeometry(diff_geom)
                outFeat.setAttributes(attrs)
                writer.addFeature(outFeat)
            except:
                ProcessingLog.addToLog(ProcessingLog.LOG_WARNING,
                                       self.tr('Feature geometry error: One or more output features ignored due to invalid geometry.'))
                continue

            feedback.setProgress(int(current * total))

        del writer
