#include <iostream>
using namespace std;

int main(int argc, char *argv[]) {
  string s;
  getline(cin, s);
  cout << "The value taken as an input using getline() is: " << s << "\n";
  return 0;
}
