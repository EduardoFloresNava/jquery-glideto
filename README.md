# jQuery glideTo
#### Create modern horizontal and vertical scrolling websites easily

jQuery glideTo is a plugin that will help you easily create scrolling navigation
websites.

Usage
-----

Just include this script after jQuery.

``` html
<script src="jquery.js"></script>
<script src="jquery.glideto.js"></script>
<script>
  $('a[href*=#]').each(function(e) {
    e.preventDefault();
    $.glideTo($(this).attr('href'));
  })
</script>
```
