# jQuery glideTo
#### Create modern horizontal and vertical scrolling websites easily

jQuery glideTo is a plugin that will can help easily create scrolling navigation
websites.

Usage
-----

Just include this script after jQuery and optionally [jQuery Easing Plugin][jquery-easing].

``` html
<script src="jquery.js"></script>
<script src="jquery.easing.js"></script>
<script src="jquery.glideto.js"></script>
<script>
  $.glideTo({
      scrollHorizontal: '#main'
  });
  $('a[href*=#]').glide();
  
</script>
```

Options
----
You can pass a variety of options to configure the plugin's behavior.

scrollHorizontal: the html element that will contain all pages.
default: '#main'

scrollVertical: the html element that will scroll to reveal the pages'
default: 'html', 'body'

duration: the duration of the animation (in milliseconds)
default: 1000

easing: the easing used on the animation
default: 'easeInOutQuad'

For more information please visit the plugin's [demo page][demo]

  [jquery-easing]: http://gsgd.co.uk/sandbox/jquery/easing/
  [demo]: http://jeduan.github.com/jquery.glideTo