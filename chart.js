var chart;
$(document).ready(function() {
   chart = new Highcharts.Chart({
      chart: {
         renderTo: 'container',
         zoomType: 'xy'
      },
      credits: {
         enabled: false
      },
      title: {
        text: 'Average Memory Usage Over Trial Runs'
      },
      subtitle: {
        text: 'per Ruby Implementation'
      },
      xAxis: [{
         categories: ["jruby-1.6.4 @ 26666 Max Chars (22 runs)", "jruby-1.6.4 @ 100000 Max Chars (13 runs)", "jruby-1.6.4 @ 500000 Max Chars (12 runs)", "jruby-1.6.4 @ 1000000 Max Chars (60 runs)", "jruby-1.6.4 @ 2000000 Max Chars (60 runs)", "ruby-1.9.2 @ 26666 Max Chars (22 runs)", "ruby-1.9.2 @ 100000 Max Chars (13 runs)", "ruby-1.9.2 @ 500000 Max Chars (12 runs)", "ruby-1.9.2 @ 1000000 Max Chars (60 runs)", "ruby-1.9.2 @ 2000000 Max Chars (60 runs)"]
      }],
      yAxis: [{ // Primary yAxis
         labels: {
            formatter: function() {
               return this.value +' bytes';
            },
            style: {
               color: '#4572A7'
            }
         },
         title: {
            text: 'Starting Memory',
            style: {
               color: '#4572A7'
            }
         },
         opposite: true

      }, { // Secondary yAxis
         gridLineWidth: 0,
         title: {
            text: 'Ending Memory',
            style: {
               color: '#89A54E'
            }
         },
         labels: {
            formatter: function() {
               return this.value +' bytes';
            },
            style: {
               color: '#89A54E'
            }
         }

      }, { // Tertiary yAxis
         gridLineWidth: 0,
         title: {
            text: 'Percentage Change',
            style: {
               color: '#AA4643'
            }
         },
         labels: {
            formatter: function() {
               return this.value +' %';
            },
            style: {
               color: '#AA4643'
            }
         },
         opposite: true
      }],
      tooltip: {
         formatter: function() {
            var unit = {
               'Starting Memory': 'b',
               'Ending Memory': 'b',
               'Percentage Change': '%'
            }[this.series.name];

            return ''+
               this.x +': '+ this.y +' '+ unit;
         }
      },
      legend: {
         layout: 'vertical',
         align: 'left',
         x: 120,
         verticalAlign: 'top',
         y: 80,
         floating: true,
         backgroundColor: '#FFFFFF'
      },
      series: [{
         name: 'Starting Memory',
         color: '#4572A7',
         type: 'spline',
         yAxis: 0,
         data: [94430.36363636363, 88732.30769230769, 88467.66666666667, 88197.86666666667, 87965.0, 3451.2727272727275, 3711.6923076923076, 3760.6666666666665, 3760.8, 3760.3333333333335]

      }, {
         name: 'Percentage Change',
         type: 'spline',
         color: '#AA4643',
         yAxis: 2,
         data: [9.272727272727273, 52.53846153846154, 135.58333333333334, 199.9, 291.6666666666667, 154.95454545454547, 393.7692307692308, 1003.5, 1772.1333333333334, 3285.95],
         marker: {
            enabled: false
         },
         dashStyle: 'shortdot'               

      }, {
         name: 'Ending Memory',
         color: '#89A54E',
         type: 'spline',
         data: [103533.45454545454, 135289.23076923078, 208878.33333333334, 264702.6666666667, 344645.3333333333, 8806.181818181818, 18320.30769230769, 41520.666666666664, 70419.8, 127341.4]
      }]
   });
});
