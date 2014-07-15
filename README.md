Sparky
==========
#### Sparkline directive using AngularJs and SVG with no other dependencies.

![ScreenShot](https://raw.githubusercontent.com/Adslot/sparky/master/examples.png)

##### Line graphs
- Multiple lines.
- Optional range marked on graph.
- Overall or per line colors.
- Fill the area under the line instead of drawing the line. 

##### Bar graphs
- Shows negative and positive items.
- Overall colors or positive, neutral, negative colors.

##### All graphs
- Scale to max value (E.g. 6 out of 10) or leave as automatic.
- Optionally scale to number of points (E.g. 15 days out of 31 days) or leave as automatic.


## Usage:
`<sparky datasets='[[0,1,2],[3,4,5]]'>` datasets takes an array of arrays.

Optional settings

`bar='true'`

`vertical-max='10'`

`point-count='30'`

`range-bottom='3'`

`range-top='4'`

`w='500'` (in pixels)

`h='200'` (in pixels)

`color-index='4'` (override the color class applied, used if you want colors to match between a multiple line graph and a single line graph.)

`filled='true'`
