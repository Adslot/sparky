{makeAngularFactory} = require '../../../../lib/utils/decorators'
angularUtils = require '../../helpers/angular'
SparkyDirective = require '../../../../client/angular/directives/sparky'

describe 'sparky', ->

  html = scopeData = null

  beforeEach ->
    angularUtils.register
      name: 'sparky'
      directives:
        sparky: makeAngularFactory SparkyDirective

  it 'should apply sparky directive', (done) ->
    html = "<sparky datasets='[[0,1,2,3,4,5,6,7,8,9,0],[0,9,8,7,6,5,4,3,2,1]]'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      expect(el.find('.line-1').length).to.be 1
      expect(el.find('.line-2').length).to.be 1
      expect(el.find('polyline').length).to.be 2
      expect(el.find('circle').length).to.be 2
      line1Polyline = el.find('.line-1 polyline')
      expect(line1Polyline.attr 'points').to.be '0,30 12,2 24,5 36,8 48,11 60,14 72,17 84,20 96,23 108,26 '
      done()


  it 'should draw a bar graph', (done) ->
    html = "<sparky datasets='[[0,-1,1,7,9,0]]' bar='true'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      expect(el.find('polyline').length).to.be 0
      expect(el.find('circle').length).to.be 0
      expect(el.find('.bar').length).to.be 6
      done()


  it 'should set up positive, warning, and negative bars', (done) ->
    html = "<sparky datasets='[[0,-1,1,7,9,0]]' bar='true'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      expect(el.find('.bar.negative').length).to.be 1
      expect(el.find('.bar.negative').attr 'x').to.be '24'
      expect(el.find('.bar.negative').attr 'y').to.be '15'
      expect(el.find('.bar.negative').attr 'height').to.be '1.4444444444444444'

      expect(el.find('.bar.warning').length).to.be 2
      expect(el.find('.bar.warning').attr 'x').to.be '0'
      expect(el.find('.bar.warning').attr 'y').to.be '15'
      expect(el.find('.bar.warning').attr 'height').to.be '0.5'

      expect(el.find('.bar.positive').length).to.be 3
      expect(el.find('.bar.positive').attr 'x').to.be '48'
      expect(el.find('.bar.positive').attr 'y').to.be '13.555555555555555'
      expect(el.find('.bar.positive').attr 'height').to.be '1.4444444444444444'
      done()


  it 'should normalise using a verticalMax', (done) ->
    html = "<sparky datasets='[[0,25,42,64,19,10]]' vertical-max='100'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      line1Polyline = el.find('.line-1 polyline')
      expect(line1Polyline.attr 'points').to.be '0,30 24,23 48,18 72,12 96,24 120,27 '
      done()


  it 'should fit horizontally using a pointCount', (done) ->
    html = "<sparky datasets='[[0,25,42,64,19,10]]' point-count='30'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      line1Polyline = el.find('.line-1 polyline')
      expect(line1Polyline.attr 'points').to.be '0,30 4,19 8,11 12,2 16,21 20,25 '
      done()


  it 'should draw a range', (done) ->
    html = "<sparky datasets='[[0,25,42,64,19,10]]' range-bottom='45' range-top='60'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      range = el.find('.range')
      expect(range.attr 'x').to.be '0'
      expect(range.attr 'y').to.be '3'
      expect(range.attr 'width').to.be '120'
      expect(range.attr 'height').to.be '6'
      done()


  it 'should scale width', (done) ->
    html = "<sparky datasets='[[0,25,42,64,19,10]]' w='200'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      line1Polyline = el.find('.line-1 polyline')
      expect(line1Polyline.attr 'points').to.be '0,30 40,19 80,11 120,2 160,21 200,25 '
      done()


  it 'should scale height', (done) ->
    html = "<sparky datasets='[[0,25,42,64,19,10]]' h='200'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      line1Polyline = el.find('.line-1 polyline')
      expect(line1Polyline.attr 'points').to.be '0,200 24,122 48,70 72,2 96,141 120,169 '
      done()


  it 'should set a color index override', (done) ->
    html = "<sparky datasets='[[0,25,42,64,19,10]]' color-index='4'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      line1Polyline = el.find('.line-1 polyline')
      expect(line1Polyline.length).to.be 0

      line4Polyline = el.find('.line-4 polyline')
      expect(line4Polyline.length).to.be 1
      done()


  it 'should draw a filled line chart', (done) ->
    html = "<sparky datasets='[[0,25,42,64,19,10]]' filled='true'>"
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      line1Polyline = el.find('.line-1 polyline')
      expect(line1Polyline.length).to.be 1
      expect(line1Polyline.attr 'points').to.be '0,30 0,30 24,19 48,11 72,2 96,21 120,25 120,30'
      done()
