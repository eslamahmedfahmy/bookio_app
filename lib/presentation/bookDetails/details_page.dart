import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bookio_app/models/models.dart';
import 'package:bookio_app/shared/functions.dart';
import 'package:flutter/material.dart';


class DetailsScreen extends StatefulWidget {
  final Book book;

  const DetailsScreen({required this.book, Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initPictureAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.book.color,
        body: Column(children: [
          _barWidget(),
          const SizedBox(height: 5),
          _imageWidget(),
          const SizedBox(height: 15),
          Text('CHAPTER 1',
              style: TextStyle(fontSize: 24, color: Colors.grey.shade400)),
          _animatedBookText()
        ]));
  }

  //custom app Bar
  Widget _barWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //wrapped with expanded to avoid text overflow
          Expanded(child: _titleWidget()),
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon:
              const Icon(Icons.arrow_back_outlined, color: Colors.white70)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.cloud_download_outlined,
                  color: Colors.white70)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.book_outlined, color: Colors.white70))
        ]));
  }

  //book title and author Widgets wrapped
  // with hero to make the transition animation
  Widget _titleWidget() {
    return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              heroWidget(
                  'tag',
                  Text(widget.book.name,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                          fontSize: 28))),
              const SizedBox(height: 5),
              heroWidget(
                  'tag2',
                  Text('By ${widget.book.author}',
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 20)))
            ]));
  }

  //Moving Image Widget
  Widget _imageWidget() {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
              offset: Offset(_animation.value, 0),
              child: const Image(
                  image: AssetImage('assets/storyImage.png'),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.fitWidth));
        });
  }

  //Book Content Text With Type Animation
  Widget _animatedBookText() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
          TypewriterAnimatedText(
              'I was sitting in Robin\'s spot at a small satellite anchor desk inside the second story...',
              speed: const Duration(milliseconds: 250),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
              cursor: '',
              textAlign: TextAlign.center)
        ]));
  }

  //--functions
  //initialize Animation for make Image Move Right And Left
  _initPictureAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _animation =
        Tween<double>(begin: 50, end: -50).animate(_animationController);

    //here i make the moving Image animation Start
    _animationController.forward();

    _animationController.addStatusListener((status) {
      //if image reach the left this check 'll make it go right again
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }

      //if image reach the right this check 'll make it go left again
      else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }
}