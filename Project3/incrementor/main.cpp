#include <bits/stdc++.h>

using namespace std;

string convert(int x, int n = 8)
{
    string s;
    for(int i = 0; i < n; i++)
    {
        if(x % 2)
            s += '1';
        else
            s += '0';
        x /= 2;
    }
    reverse(s.begin(), s.end());
    return s;
}

int main()
{
    vector<string> s;
    for (int i = 0; i < (1<<8); i++)
        s.push_back(convert(i, 8));
    ofstream o("8bit_incrementor_TV.tv");
    int cnt = 0;
    vector <string> v;
    for(int i = 0; i < (1<<8); i++)
    {
        string tmp;
        tmp = convert(i) + '_' + convert(i+1, 9);
        v.push_back(tmp);
        cnt ++;
    }
    random_shuffle(v.begin(), v.end());
    for(auto i : v)
        o << i << endl;
    cout << cnt;
    return 0;
}
