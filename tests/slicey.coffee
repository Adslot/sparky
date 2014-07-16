{makeAngularFactory} = require '../../../../lib/utils/decorators'
angularUtils = require '../../helpers/angular'
SliceyDirective = require '../../../../client/angular/directives/slicey'

describe 'slicey', ->

  html = scopeData = null

  beforeEach ->
    angularUtils.register
      name: 'slicey'
      directives:
        slicey: makeAngularFactory SliceyDirective
      templates:
        'slicey': require '../../../../lib/views/components/slicey.jade'


  it 'should apply slicey directive', (done) ->

    html = '''<slicey dataset="[{status: 'live', value: 5}, {status: 'pending', value: 3}]"></slicey>'''
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      background = el.find('.background')
      expect(background.length).to.be 1
      expect(background.attr 'r').to.be '179'
      expect(background.attr 'cx').to.be '180'
      expect(background.attr 'cy').to.be '180'

      live = el.find('.live')
      expect(live.length).to.be 1
      expect(live.attr 'd').to.be 'M180,180 L180,0 A180,180 0 1,1 53,307 z'

      pending = el.find('.pending')
      expect(pending.length).to.be 1
      expect(pending.attr 'd').to.be 'M180,180 L53,307 A180,180 0 0,1 180,0 z'

      expect(el.find('.donut').length).to.be 0

      expect(el.attr 'width').to.be '100'
      expect(el.attr 'height').to.be '100'
      done()


  it 'should draw a donut circle', (done) ->

    html = '''<slicey dataset="[{status: 'live', value: 5}, {status: 'pending', value: 3}]" donut='true'></slicey>'''
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      donut = el.find('.donut')
      expect(donut.length).to.be 1
      expect(donut.attr 'r').to.be '90'
      expect(donut.attr 'cx').to.be '180'
      expect(donut.attr 'cy').to.be '180'
      done()


  it 'should use the diameter given', (done) ->

    html = '''<slicey dataset="[{status: 'live', value: 5}, {status: 'pending', value: 3}]" diameter='400'></slicey>'''
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      expect(el.attr 'width').to.be '400'
      expect(el.attr 'height').to.be '400'
      done()
