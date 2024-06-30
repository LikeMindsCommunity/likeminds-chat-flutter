/// List extension methods
/// used to extend the functionality of List class
/// and add some extra methods to it
extension LMChatListExtension on List {
  /// Copy the list
  /// return a new list with the same elements
  List<T> copy<T>() {
    return <T>[...this];
  }
}
