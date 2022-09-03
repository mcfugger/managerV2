import 'package:manager/src/models/manager.dart';
import 'package:manager/src/models/observer.dart';
import 'package:manager/src/models/task_event.dart';
import 'package:meta/meta.dart';

mixin ObservableManagerMixin<T> on Manager<T> {
  final List<ManagerObserver> _observers = [];

  @visibleForTesting
  List<ManagerObserver> get observers => [..._observers];

  @visibleForTesting
  void addObserverTest(ManagerObserver<T> observer) {
    addObserver(observer);
  }

  @visibleForTesting
  void removeObserverTest(ManagerObserver<T> observer) {
    removeObserver(observer);
  }

  @visibleForTesting
  void initializeTest() => initialize();

  @protected
  void addObserver(ManagerObserver<T> observer) {
    _observers.add(observer);
  }

  @protected
  void removeObserver(ManagerObserver<T> observer) {
    _observers.remove(observer);
  }

  @mustCallSuper
  @override
  void onEventCallback(TaskEvent<T> event) {
    for (var observer in _observers) {
      observer.onEvent(this, event);
    }
    super.onEventCallback(event);
  }

  @mustCallSuper
  @protected
  void initialize() {
    for (var observer in _observers) {
      observer.onCreated(this);
    }
  }

  @mustCallSuper
  @override
  void dispose() {
    for (var observer in _observers) {
      observer.onDisposed(this);
    }
    _observers.clear();
    super.dispose();
  }

  @mustCallSuper
  @override
  void mutateState(newState) {
    final potentialState = newState;
    super.mutateState(newState);
    final finalState = state;
    for (var observer in _observers) {
      observer.onStateMutated(potentialState, finalState);
    }
  }
}