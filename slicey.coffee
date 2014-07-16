module.exports = class SliceyDirective

  restrict: 'E'
  templateUrl: 'slicey'
  replace: true
  scope:
    dataset: '='
    donut: '='
    diameter: '@'


  link: (scope, element, attrs) =>
    values = @getValues scope.dataset
    scope.total = @getTotal values
    scope.arcs = @getArcs scope.dataset, scope.total


  getValues: (dataset) ->
    dataset.map (datum) -> datum.value


  getTotal: (values) ->
    total = 0
    for value in values
      total += value
    return total


  getPointX: (angle) ->
    return Math.round 180 + 180 * Math.cos(Math.PI * angle / 180)


  getPointY: (angle) ->
    return Math.round 180 + 180 * Math.sin(Math.PI * angle / 180)


  getArcs: (dataset, total) =>
    arcs =  []
    startAngle = 0
    endAngle = -90

    for datum in dataset
      angle = 360 * datum.value / total

      startAngle = endAngle
      endAngle += angle

      arc =
        x1: @getPointX startAngle
        y1: @getPointY startAngle
        x2: @getPointX endAngle
        y2: @getPointY endAngle
        largeArcFlag: if angle > 180 then 1 else 0
        color: datum.status
      arcs.push arc

    return arcs
