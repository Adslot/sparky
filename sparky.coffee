_ = require 'underscore'
template = require '../../../lib/views/components/sparky.jade'

module.exports = class SparkyDirective

  restrict: 'E'
  template: template
  replace: true
  scope:
    datasets: '='
    bar: '='
    verticalMax: '='
    pointCount: '='
    rangeBottom: '='
    rangeTop: '='
    w: '='
    h: '='
    colorIndex: '@'
    filled: '='

  link: (scope, element, attrs) =>
    scope.dimensions =
      width: scope.w ? 120
      height: scope.h ? 30

    pointSets = scope.datasets

    pointCount = scope.pointCount ? @getPointCount pointSets

    if scope.bar
      normaliser = @getNormaliser scope.dimensions.height / 2, pointSets, scope.verticalMax

      scope.bars = @getBars scope.dimensions, pointSets, normaliser, pointCount

      scope.barsWidth = Math.floor scope.dimensions.width / (pointCount + 1)

    else
      normaliser = @getNormaliser scope.dimensions.height, pointSets, scope.verticalMax

      scope.lines = @getLines scope.dimensions, pointSets, normaliser, pointCount, scope.colorIndex, scope.filled

      scope.range = @getRange scope.dimensions, normaliser, scope.rangeBottom, scope.rangeTop


  getPointSetMax: (pointSets) ->
    allPoints = _.flatten pointSets
    return Math.max allPoints...


  getPointCount: (pointSets) ->
    lengths = []
    for set in pointSets
      lengths.push set.length
    return Math.max lengths...


  getNormaliser: (height, pointSets, pointSetMax) =>
    pointSetMax = pointSetMax ? @getPointSetMax pointSets
    # -2 allows the circle to fit.
    return (height - 2) / pointSetMax


  getNormalisedPointSet: (pointSet, normaliser) ->
    return pointSet.map (point) -> point * normaliser


  getPointX: (index, width, pointCount) ->
    return 0 + (index * (width / (pointCount - 1)))


  getPointY: (index, height, pointSet) ->
    return Math.floor height - pointSet[index]


  getPoint: (index, dimensions, pointSet, pointCount) =>
    return "#{Math.floor @getPointX(index, dimensions.width, pointCount)},#{@getPointY(index,
        dimensions.height, pointSet)} "


  getPolyline: (dimensions, pointSet, pointCount, filled) =>
    polylineData = ''
    if filled then polylineData += "0,#{dimensions.height} "
    polylineData += @getPoint index, dimensions, pointSet, pointCount for point, index in pointSet
    if filled
      polylineData += "#{Math.floor @getPointX(pointSet.length - 1, dimensions.width, pointCount)},#{dimensions.height}"
    return polylineData


  getCircle: (dimensions, pointSet, pointCount) =>
    circle =
      x: Math.floor @getPointX pointSet.length - 1, dimensions.width, pointCount
      y: @getPointY pointSet.length - 1, dimensions.height, pointSet
    return circle


  getLine: (dimensions, pointSet, normaliser, pointCount, numberOfPointSets, indexOfPointSet, colorIndex, filled) =>
    line = {}
    normalisedPointSet = @getNormalisedPointSet pointSet, normaliser
    line.polyline = @getPolyline dimensions, normalisedPointSet, pointCount, filled
    line.circle = @getCircle dimensions, normalisedPointSet, pointCount
    line.index = colorIndex ? numberOfPointSets - indexOfPointSet
    return line


  getLines: (dimensions, pointSets, normaliser, pointCount, colorIndex, filled) ->
    lines = []
    for pointSet, index in pointSets
      lines.push @getLine dimensions, pointSets[index], normaliser, pointCount, pointSets.length, index, colorIndex, filled
    return lines


  getRange: (dimensions, normaliser, bottom, top) ->
    range =
      top: Math.floor dimensions.height - top * normaliser
      height: Math.floor (top - bottom) * normaliser
      width: dimensions.width
    return range


  getBar: (dimensions, point, pointCount, index) =>
    halfway = dimensions.height / 2
    if point < 0
      y = halfway
      colorClass = 'negative'
    else
      y = halfway - point
      colorClass = 'positive'
    if point is 0
      colorClass = 'warning'
    bar =
      height: Math.max 0.5, Math.abs point # So 0 value shows as a half pixel line instead of nothing.
      x: @getPointX index, dimensions.width, pointCount
      y: y
      class: colorClass
    return bar


  getBars: (dimensions, pointSets, normaliser, pointCount) ->
    normalisedPointSet = @getNormalisedPointSet pointSets[0], normaliser
    bars = []
    for point, index in normalisedPointSet
      bars.push @getBar dimensions, point, pointCount, index
    return bars
