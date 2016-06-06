export default {

  //http://stackoverflow.com/questions/10073699/pad-a-number-with-leading-zeros-in-javascript
  pad: function(n, width, z) {
      z = z || '0';
      width = width || 2;
      n = n + '';
      return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
  },

  formatTime(milliseconds) {
    var d = moment.duration(milliseconds);
    var result = this.pad(d.minutes()) + ":" + this.pad(d.seconds());
    if (d.hours() > 0) {
        result = this.pad(d.hours()) + ":" + result;
    }
    return result;
  },

  humanizeDate(date) {
      return moment(date).fromNow();
  }

};