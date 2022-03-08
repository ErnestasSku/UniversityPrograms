#include <iostream>
#include "adsvector.h"

void handleErrors(int flag);

int main()
{
    ads::vector<int> **A;
    A = (ads::vector<int>**)calloc(10, sizeof(ads::vector<int>*));
    int size = 0, last = 0;

    std::string menu = "Iveskite: exit kad baigtumete programa\nnew - sukurti nauja vektoriu\ndelete - sunaikinti vektoriu\npush - prideti elementa i pabaiga\ninsert - ideti elementa i nurodyta indeksa\nremoveAll - pasalinti visus elementus\nerase - pasalinti viena elementa nurodytame indekse\npop - kad pasalintumete paskutini vektoriaus elementa\nchange - pakeisti viena elementa indekse\nempty - suzinoti ar vektorius tuscias\nsize - suzininoti vektoriaus dydi\nprint - isvesti visus vektoriaus elementus\nlist - parodo visus vektorius\npushBulk - kad ivevestumete keleta skaiciu vienu metu\nhelp - kad pamatytumete sita menu\n";

    std::cout << menu;
    
    while (true)
    {
        int flag = 0;
        std::string input;
        std::cout << "\nIveskite operacija\n"; std::cin >> input;
        
        if (input == "exit")
        {
            return 0;
        }
        else if(input == "new")
        {
            bool empty = false;
            int index = 1;

            for (int i = 1; i <= 10; i++)
            {
                index = i;
                if(A[i] == nullptr)
                    {
                        empty = true;
                        break;
                    }
            }
            if(index == 10)
                {
                    std::cout << "Klaidos kodas: -5 Daugiau vektoriu neina sukurti\n";
                    flag = 0;
                    continue;
                }
            ads::vector<int> *newVector = new ads::vector<int>;
            A[index] = newVector; 
            
            last = std::max(last, index);

            std::cout << "Vektorius sukurtas " << index << " indekse\n";
            flag = 0;            

        }
        else if(input == "delete")
        {   
            std::cout << "Pasirinkite indeksa\n";
            int index; std::cin >> index;

            ads::vector<int> *temp = A[index];
            delete temp;
            A[index] = nullptr;
            flag = 2;

            if(index == last)
                last--;

        }
        else if(input == "push")
        {
            int vector, data;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;
            

            if(A[vector] == nullptr)
            {
                flag = -4;
            }
            else{

                std::cout << "Duomenys "; std::cin >> data;
                ads::vector<int> *temp = A[vector];
                flag = temp->pushBack(data);
            }

        }
        else if(input == "insert")
        {
            int vector, data, index;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;
            
            if(A[vector] == nullptr)
            {
                flag = -4;
            }
            else{
                std::cout << "Pasirinkite indeksa\n"; std::cin >> index;
                std::cout << "Duomenys \n"; std::cin >> data;
                ads::vector<int> *temp = A[vector];
                flag = temp->pushAt(index, data);
            }
        }
        else if(input == "removeAll")
        {
            int vector, index;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;

            if(A[vector] == nullptr)
            {
                flag = -4;
            }
            else{
                ads::vector<int> *temp = A[vector];
                temp->removeAllElements();
            }
        }
        else if(input == "erase")
        {
            int vector, index, dataIndex;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;

            if(A[vector] == nullptr)
            {
                flag = -4;
            }
            else{
                std::cout << "Pasirinkite pozicija "; std::cin >> dataIndex;
                ads::vector<int> *temp = A[vector];
                flag = temp->removeElementAt(dataIndex);
            }
        }
        else if(input == "pop")
        {
            int vector;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;

            if(A[vector] == nullptr)
            {
                flag = -4;
            }else{
                ads::vector<int> *temp = A[vector];
                flag = temp->pop();
            }
        }
        else if(input == "change")
        {
            int vector, index, data;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;

            if(A[vector] == nullptr)
            {
                flag = -4;
            }
            else{
                std::cout << "Pasirinkite pozicija\n"; std::cin >> index;
                std::cout << "Nauji duomeny\n"; std::cin >> data;
                ads::vector<int> *temp = A[vector];
                flag = temp->setElementAt(index, data);
            }
        }
        else if(input == "empty")
        {
            int vector;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;
            
            if(A[vector] == nullptr)
            {
                flag = -4;
            }
            else{
                ads::vector<int> *temp = A[vector];
                if (temp->isEmpty())
                {
                    std::cout << "Vektorius yra tuscias\n";
                }else{
                    std::cout << "Vektorius nera tuscias\n";
                }
                
            }
        }
        else if(input == "size")
        {
            int vector;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;
            
            if(A[vector] == nullptr)
            {
                flag = -4;
            }
            else{
                ads::vector<int> *temp =  A[vector];
                std::cout << "Vektoriaus dydys " << temp->size() << "\n";
            }
        }
        else if(input == "print")
        {
            int vector;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;

            if(A[vector] == nullptr)
            {
                flag = -4;
            }
            else{

                ads::vector<int> *temp = A[vector];
                for (int i = 0; i < (*temp).size(); i++)
                {
                    std::cout << (*temp).at(i) << " ";
                    
                }
            }
            
        }
        else if(input == "list")
        {
            for (int i = 1; i <= last; i++)
            {
                if(A[i] == nullptr)
                    std::cout << "null ";
                else
                    std::cout << i << " ";
            }
            
        }
        else if(input == "pushBulk")
        {
            int vector;
            std::cout << "Pasirinkite vektoriu\n"; std::cin >> vector;

            if(A[vector] == nullptr)
            {
                flag = -4;
            }
            else{
                int repeat, data;
                std::cout << "Kiek kartu "; std::cin >> repeat;
                
                ads::vector<int> *temp = A[vector];
                for (int i = 0; i < repeat; i++)
                {
                   std::cout << "Duomenys "; std::cin >> data;
                flag = temp->pushBack(data);
                }
                

            }
        }
        else if(input == "help")
        {
            std::cout << menu << "\n";
        }
        else{

        }
        handleErrors(flag);

    }
    


    return 0;
}

