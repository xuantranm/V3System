//an image width in pixels
var imageWidth = 600;
//DOM and all content is loaded
$(window).ready(function () {
    var currentImage = 0;
    //set image count
    var allImages = $('#slideshow li img').length;
    //setup slideshow frame width
    $('#slideshow ul').width(allImages * imageWidth);
    //attach click event to slideshow buttons
    $('.slideshow-next').click(function () {
        //increase image counter
        currentImage++;
        //if we are at the end let set it to 0
        if (currentImage >= allImages) currentImage = 0;
        //calcualte and set position
        setFramePosition(currentImage);
    });

    $('.slideshow-prev').click(function () {
        //decrease image counter
        currentImage--;
        //if we are at the end let set it to 0
        if (currentImage < 0) currentImage = allImages - 1;
        //calcualte and set position
        setFramePosition(currentImage);
    });
});

//calculate the slideshow frame position and animate it to the new position
function setFramePosition(pos) {
    //calculate position
    var px = imageWidth * pos * -1;
    //set ul left position
    $('#slideshow ul').animate({
        left: px
    }, 300);
}