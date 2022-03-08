#include<bits/stdc++.h>
// #include "deque.h"

using namespace std;

#define nl cout << "\n";

string taskDescription = "3. Priėmimo komisija (ADT: dekas, ilgas sveikas skaičius).  Procesas: priėmimo komisijoje dirba 2 darbuotojos, \nkurių produktyvumas skirtingas, jos priima stojančiųjų prašymus ir stato į lentyną, kiekviena iš savo pusės, \nkai nėra stojančiųjų ir pasibaigus tos dienos priėmimui, jos ima stojančiųjų prašymus ir juos sutvarko. \nTikslas: patyrinėti, kiek laiko reikia skirti prašymų tvarkymui, pasibaigus jų priėmimui. Pradiniai duomenys: \ndarbuotojų produktyvumas (abi darbuotojos prašymo priėmimui sugaišta vienodai laiko, bet prašymo sutvarkymui skirtingai laiko), \nstojančiojo atėjimo tikimybė (galima realizacija: generuojamas atsitiktinis skaičius ir tikrinama, ar jis tenkina tam tikrą sąlygą), \ndokumentų priėmimo laikas. Rezultatai: papildomas darbo laikas, kuris turi būti skiriamas prašymų tvarkymui, \ndarbuotojų užimtumas (procentais), nes galima situacija, kad pagal pateiktus pradinius duomenis stojančiųjų intensyvumas toks nedidelis, \nkad dalį laiko darbuotojos poilsiauja.";

int main()
{  
    /**
     * 1st step:
     * 
     * Read initial data
     * 
     */

    int receptionSpeed;
    int firstWorkerSpeed, secondWorkerSpeed;
    int time, chance; 

    string inputName, outputName;
    inputName = "data3.txt";
    outputName = "isvestis3.txt";
    // cout << "Failo ivesties pavadinimas: ";
    // cin >> inputName;
    // cout << "Failo isvesties pavadinimas: ";
    // cin >> outputName;

    
    

    ifstream cin(inputName);
    cin >> receptionSpeed >> firstWorkerSpeed >> secondWorkerSpeed >> time >> chance;
    cin.close();

    
    ofstream fout(outputName);
    fout << "Ernestas Škudzinskas, 4 grupė\n" << taskDescription \
    << "\n\nI Dalis - pradiniai duomenys" \
    << "\n\t1) Priėmimo trukmė " << receptionSpeed << " min"\
    << "\n\t2) Darbuotojų našumas. Pirmos: " << firstWorkerSpeed << " min/prašymas. " << "Antros: " << secondWorkerSpeed << " min/prašymas" \
    << "\n\t3) Priėmimo laikas: " << (time * 60) << " min." \
    << "\n\t4) Kliento atvykimo tikimybė " << chance << "%\n\n";

    int positionInQueue = 0;
    vector<int> waitingLine;
    bool firstWorkerWorking, secondWorkerWorking;
    firstWorkerWorking = secondWorkerWorking = false;
    int firstWorkerReceptionTime, secondWorkerReceptionTime;
    int timeWorked = 0;
    firstWorkerReceptionTime = secondWorkerReceptionTime = 0;
    deque<int> jobs;
    srand(117649); //FIXME: maybe change it to a random value
    int i = 1;

    fout << "II dalis - vykdymas\n" \
    << "(T - minutės)" \
    << "\n\nT =    0. Pradeda darbą\n";
    for (; i <= time * 60 ; i++)
    {
        // cout << rand() % 100 + 1 << " ";
        fout << "\nT = " << setw(4) << i << "\n\t";
        int randomisedNumber = rand() % 100 + 1;
        if(randomisedNumber <= chance && (i + receptionSpeed) <= (time * 60) )
        {
            waitingLine.push_back( waitingLine.size() + 1);
            fout << "Į eilę atėjo " << waitingLine.size() << " klientas.";
        }
        fout << "Eilėjė stovi " << (waitingLine.size() - positionInQueue) << " klientų.\n";
        fout << "\tEilė: ";
        for(int j = positionInQueue; j < waitingLine.size(); j++)
            fout << j+1 << " ";
        fout << "\n\t";        
        //There is a new customer
        if(waitingLine.size() > positionInQueue)
        {
           if(!firstWorkerWorking && !secondWorkerWorking)
           {
               if(firstWorkerReceptionTime <= secondWorkerReceptionTime)
               {
                    fout << "Pirma darbuotoja priima klientą " << positionInQueue + 1;
                    firstWorkerWorking = true;
                    firstWorkerReceptionTime = i;
                    positionInQueue++;
                    jobs.push_front(positionInQueue);
                    timeWorked += receptionSpeed;
               }else{
                    fout << "Antra darbuotoja priima klientą " << positionInQueue + 1; 
                    secondWorkerWorking = true;
                    secondWorkerReceptionTime = i;
                    positionInQueue++;
                    jobs.push_back(positionInQueue);
                    timeWorked += receptionSpeed;
               }
           }else if(!firstWorkerWorking)
           {
                fout << "Pirma darbuotoja priima klientą " << positionInQueue + 1;
                firstWorkerWorking = true;
                firstWorkerReceptionTime = i;
                positionInQueue++;
                jobs.push_front(positionInQueue);
                timeWorked += receptionSpeed;
           }else if(!secondWorkerWorking)
           {
                fout << "Antra darbuotoja priima klientą " << positionInQueue + 1; 
                secondWorkerWorking = true;
                secondWorkerReceptionTime = i;
                positionInQueue++;
                jobs.push_back(positionInQueue);
                timeWorked += receptionSpeed;
           }
        }
      
        if(firstWorkerWorking && (firstWorkerReceptionTime + receptionSpeed) <= i)
            {
                firstWorkerWorking = false;
                fout << "Pirma darbuotoja atliko priėmima.";
            }
        if(secondWorkerWorking && (secondWorkerReceptionTime + receptionSpeed) <= i)
            {
                secondWorkerWorking = false;
                fout << "Antra darbuotoja atliko priėmima.";
            }

    }
    fout << "\n\n\tBaigės priėmimų laikas" \
    << "\n\tAtėjo klientų: " << waitingLine.size() \
    << "\n\tDarbuotojos pradeda tvarkyti prašymus\n";
    
    for(auto e : jobs)
        cout << e << " ";

    while(jobs.size() > 0 || firstWorkerWorking || secondWorkerWorking )
    {   
        i++;
        fout << "\nT = " << setw(4) <<  i << ".\n\t";

        if(firstWorkerWorking && (firstWorkerReceptionTime + firstWorkerSpeed) <= i)
            {
                firstWorkerWorking = false;
                fout << "Pirma darbuotoją baigė tvarkyti prašymą. ";
            }
        if(secondWorkerWorking && (secondWorkerReceptionTime + secondWorkerSpeed) <= i)
            {
                secondWorkerWorking = false;
                fout << "Antra darbuotoją baigė tvarkyti prašymą. ";
            }

        if(!firstWorkerWorking && jobs.size() > 0)
        {
            firstWorkerWorking = true;
            int temp = jobs.front();
            fout << "Pirma darbuotoją pradėjo tvarkyti " << temp << " prašymą. ";
            timeWorked += firstWorkerSpeed;
            firstWorkerReceptionTime = i;
            jobs.pop_front();
        }

        if(!secondWorkerWorking && jobs.size() > 0)
        {
            secondWorkerWorking  = true;
            int temp = jobs.back();
            fout << "Antra darbuotoją pradėjo tvarkyti " << temp << " prašymą. ";
            timeWorked += firstWorkerSpeed;
            secondWorkerReceptionTime = i;
            jobs.pop_back();
        }

    }

    fout << "\n\nIII dalis - rezultatai\n";
    fout << "\tLaikas skirtas dokumentų tvarkymui: " << (i - (time * 60)) << "\n";
    fout << "\tDarbuotojų užimtumas: " << setprecision(4) << ((double(timeWorked) / i) / 2.) * 100 << "%";
    
    return 0;
}