module.exports = class SliceyDirective

  restrict: 'E'
  templateUrl: 'slicey'
  replace: true
  scope:
    dataset: '='
    donut: '='
    diameter: '@'


  QUARTER = Math.PI / 2
  HALF = Math.PI
  ROUND = Math.PI * 2
  RADIUS = 0.5


  link: (scope, element, attrs) =>
    values = @getValues scope.dataset
    scope.total = @sum values
    scope.arcs = @getArcs scope.dataset, scope.total


  getValues: (dataset) ->
    dataset.map (datum) -> datum.value


  sum: (values) ->
    total = 0
    for value in values then total += value
    return total


  getPointX: (angle) ->
    return RADIUS * Math.cos angle


  getPointY: (angle) ->
    return RADIUS * Math.sin angle


  getArcs: (dataset, total) =>
    arcs = new Array dataset.length
    startAngle = 0
    endAngle = -QUARTER

    for datum, index in dataset
      angle = ROUND * datum.value / total

      startAngle = endAngle
      endAngle += angle

      arcs[index] =
        x1: @getPointX startAngle
        y1: @getPointY startAngle
        x2: @getPointX endAngle
        y2: @getPointY endAngle
        largeArcFlag: if angle > HALF then 1 else 0
        color: datum.status

    return arcs
