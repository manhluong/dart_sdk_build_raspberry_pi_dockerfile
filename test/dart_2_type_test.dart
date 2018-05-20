// From here: https://medium.com/dartlang/dart-gets-a-type-system-6bd3121772de

void main() {
  cleanUp([new TempFile(), new BankAccount()]);
}
void cleanUp(List<TempFile> files) =>
    files.forEach((f) => f.delete());
class TempFile {
  void delete() => print('TempFile deleted.');
}
class BankAccount {
  void delete() => print('BankAccount deleted. Whoops!');
}
