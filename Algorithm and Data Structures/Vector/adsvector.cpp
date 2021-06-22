#include<adsvector.h>

string succesCodes[] ={
"","Ivykdymo kodas: 1 Operacija ivykdyta sekmingai\n",
"Ivykdomo kodas: 2 vektorius sunaikintas\n"};

string errorCodes[] = {
    "",
    "Klaidos kodas: -1 Negalima alokuoti atiminties\n",
    "Klaidos kodas: -2 Eile yra tuscia\n",
    "Klaidos kodas: -3 Indeksas yra uz eiles ribu\n",
    "Klaidos kodas: -4 Vektorius neegzistuoja\n";
};

namespace ads
{
    /**
         * vector class contstructor.
         * It initializes a new vector
         * and allocates memory
    */
    template<typename T>
    vector<T>::vector()
    {
         capacity = increment;
         current = 0;
         arr = (T*)calloc(capacity, sizeof(T));
         //arr = new T[capacity] //we can use new in c++, but in this case i use realloc from c
    }
    
     /**
         * vector class destructor
         * It clears the memory when the vector is destroyed
    */
    template<typename T>
    vector<T>::~vector()
    {
        free(arr);
    }

    /**
         * A function which checks if vector is empty
    */
    template<typename T>
    bool vector<T>::isEmpty()
    {
        if (current == 0)
        {
            return true;
        }else
            return false;
        
    }
    /**
     * A function which returns the size of a vector
    */   
    template<typename T>
    int vector<T>::size()
    {
        return current;
    }

    /**
         * A function which returns the current maximum size of a vector
    */
    template<typename T>
    int vector<T>::getCapacity()
    {
        return capacity;
    }

    /**
         * A function which removes all the elements
    */
    template<typename T>
    void vector<T>::removeAllElements()
    {
        free(arr);
        current = 0;
        arr = (T*)calloc(capacity, sizeof(T));
    }

    /**
         * Removes element at a specified location
    */
    template<typename T>
    int vector<T>::removeElementAt(int Index)
    {
        if (current <= 0)
            return -3;
        
        for (int i = Index; i < current; i++)
        {
            arr[i] = arr[i+1];
        }
        current--;
        return 1;
    }
    
    /**
         * Pushes an element to the back of an array
         * 
         * returns 1 if the push was successful
         * returns -1 if it couldn't reallocate memory
    */
    template<typename T>
    int vector<T>::pushBack(T data)
    {
        if (current + 1 >= capacity)
        {
            T *temp = arr;
            capacity += increment;
            //capacity *= 2;
            arr = (T*)realloc(arr, capacity * sizeof(T));
            if (arr == nullptr)
                {
                    arr = temp;
                    return -1;
                }
            
        }
        arr[current++] = data;
        return 1;
    }

    /**
         * Pushes element at a specified location
         * 
         * returns 1 if it was successful
         * returns -1 if it couldn't reallocate memory
    */
    template<typename T>
    int vector<T>::pushAt(int Index, T data)
    {
        int flag;
        if (Index > current)
        {
            flag = pushBack(data);
            return flag;
        }

        if (current + 1 >= capacity)
        {
            T *temp = arr;
            capacity += increment;
            //capacity *= 2;
            arr = (T*)realloc(arr, capacity * sizeof(T));
            if (arr == nullptr)
                {
                    arr = temp;
                    return -1;
                }
            
        }
        
        for (int i = current; i > Index; i--)
        {
            arr[i] = arr[i-1];
        }
        arr[Index] = data;
        current++;
        return 1;
    }

    /**
         * Changes element at a specified location
         * 
         * returns 1 if the change was successfull
         * returns -1 if the element couldn't be changed (the element is out of array)
    */
    template<typename T>
    int vector<T>::setElementAt(int index, T data)
    {
        if(index > current)
            return -3;
        arr[index] = data;
        return 1;
    }

    /**
         * A function which returns a value at said location
    */
    template<typename T>
    T vector<T>::at(int index)
    {
        if(index < current)
            return arr[index];
    }

    /**
         * A function which deletes the last element
         * 
         * returns 1 if it was successfull
         * returns -1 if it couldn't delete last element (it is an empty array)
    */
    template<typename T>
    int vector<T>::pop()
    {
        if(current > 0)
        {
            current--;
            return 1;
        }else
            return -2;
    }

    /**
         * A function which resizes vector to 
         * use only the required amount of memory
     */
    template<typename T>
    int vector<T>::resize()
    {
        T *temp = arr;
        arr = (T*)realloc(arr, current * sizeof(T));
        if (arr == nullptr)
        {
            arr = temp; 
            return -1;
        }else
            return 1;
    }

     /**
         * Operator [] overloading for easier access of the array elements;
    */
    template<typename T>
    T vector<T>::operator[] (int Index)
    {
        if (Index < current)
        {
            return arr[Index];
        }
        
        
    }

}

void handleErrors(int flag)
{
    if(flag > 0)
        std::cout << succesCodes[flag] << "\n";
    else
    {
        flag *= -1;
        std::cout << errorCodes[flag] << "\n";

    }
}