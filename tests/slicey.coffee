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
      expect(background.attr 'r').to.be '.49'
      expect(background.attr 'cx').to.be '0'
      expect(background.attr 'cy').to.be '0'

      live = el.find('.live')
      expect(live.length).to.be 1
      expect(live.attr 'd').to.be 'M0,0 L3.061616997868383e-17,-0.5 A0.5,0.5 0 1,1
      -0.35355339059327373,0.3535533905932738 z'

      pending = el.find('.pending')
      expect(pending.length).to.be 1
      expect(pending.attr 'd').to.be 'M0,0 L-0.35355339059327373,0.3535533905932738 A0.5,0.5 0 0,1
      -9.184850993605148e-17,-0.5 z'
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
      expect(donut.attr 'r').to.be '.25'
      expect(donut.attr 'cx').to.be '0'
      expect(donut.attr 'cy').to.be '0'
      done()


  it 'should use the diameter given', (done) ->

    html = '''<slicey dataset="[{status: 'live', value: 5}, {status: 'pending', value: 3}]" diameter='400'></slicey>'''
    angularUtils.compileHtml html, scopeData, (err, {el, scope}) ->
      if err then return done err

      expect(el.attr 'width').to.be '400'
      expect(el.attr 'height').to.be '400'
      done()
