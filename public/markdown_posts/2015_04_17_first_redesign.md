# First Redesign: A little SASSy

My mother is [an artist](http://www.artistblip.com/), and a very good one at that.  I am not.  From before kindergarten, I've always been a mathy person.  When I was younger, I used to think that I could turn that into a career in architecture and continue my mom's legacy, until I learned that you apparently need to be really good at a ton of things to be an architect (including but not limited to drawing).

A majority of my software development experience came on the backend; writing queries, designing architectures (although not the kind I originally wanted to), and implementing business logic.  Frontend things were more of a nuisance.  I really believe in the importance of user-focused interface design and user experience, I found the tools clunky.  I would often just slap on a skin to my app and give up on customization.

A friend of mine turned me on to [an excellent post on UI design for engineers](https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-1-559d4e805cda) by @erickennedy, and it completely turned me around on the issue.  It reminded me of how important it is to be able to control your design.  It also helped me realize that nobody can really be "bad at art" (and I mean little-a art, not big-a Art.  I'm sure we're all bad at Art to people who call it Art).  What discouraged me when I was younger was that I wanted to put the image in my head onto the canvas, but I lacked the skill to do that with a pencil or a paint brush.  That same frustration informed my opinion about web design, but I realized I'd never given an honest shot at working on my "paintbrush skill".

After a little work, I have a new appreciation for CSS and languages that compile to CSS like SASS.  If you were like me, be like Drake and ~~star on a young adult TV show in Canada~~ start at the bottom.  Check out [Code Academy's CSS lessons](http://www.codecademy.com/learn).  Watch youtube videos.  Read some tutorials.  Having the humility to relearn things is integral to being a good software developer and a good person in general.

A quick note on SASS: if you haven't used it before and are coming from a CSS background, it's really really useful.  It allows you to add a little bit of logic into your design, like variables and functions.  A really easy usecase is to keep track of colors in your app.  Instead of messing around with all of the hex color pickers, choose a default color for your app and use SASS's `lighten()` and `darken()` methods to get different shades of that color.

    // app/assets/stylesheets/variables.css.scss
    $secondary-background-color: #BFA891;

    // app/assets/stylesheets/posts.css.scss
    ul.short-posts li:hover {
      background-color: lighten($secondary-background-color, 30%);
    }

This accomplishes few things.  First, it cleans up the CSS and makes it easier to read.  Second, it decouples the app CSS from the choice of colors, so if I wanted to try out different colors, I could do it by changing one line in my `variables` file.  I also think it's much easier using a method than bouncing around a color picker trying to find the color that I want.

SASS has a [lot of other great functions](http://sass-lang.com/documentation/Sass/Script/Functions.html) and it also lets you define your own.  When Rails defaulted to using SASS my first thought was that it was an unnecessary move and added bloat.  Now I see that it was yet another nudge towards better code.

After looking into CSS and SASS a bit more, I redesigned the display of my app.  You can view the history of the different iterations of this site by clicking on the `SITE ITERATIONS` link at the top of the page.  The next iteration will most likely be to make it mobile friendly, and you can be sure I'll make a quick post about that.

As an aside, I don't believe that artistic talent skips a generation.  My brother is an excellent artist, and I recommend his most recent webcomic, Two Steps Back.  My favorite one features [IBM's Watson, haphazard spending, and the misfortunes of being too transparent](http://www.twostepsbackcomic.com/?comic=elementary-my-dear-watson).