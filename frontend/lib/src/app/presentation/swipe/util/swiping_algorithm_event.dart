import 'dart:async';

class SwipingAlgorithmEvent {
   final StreamController<int> _controller = StreamController<int>.broadcast();
   int _currentAlgoId = 0;

   Stream<int> get algoIdChanged => _controller.stream;

   void changeAlgoId(int algoId) {
      _currentAlgoId = algoId;
      _controller.add(algoId);
   }

   Future<int> getAlgoId() async {
      return _currentAlgoId;
   }
}
