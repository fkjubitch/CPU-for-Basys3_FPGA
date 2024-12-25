// Encode = UTF-8
#include<iostream>
#include<string>
#include<vector>
#include<map>
#include<sstream>
#include<stack>

using namespace std;

/*
    asm format:
        //params always written in decimal
        R-Type: OP rd rs rt (Imple: OP rs rt rd 00000 Funct)
            e.g. add 1 2 3 (add $1,$2,$3)

        I-Type: OP rt rs immi (Imple: OP rs rt immi)
            e.g. addi 1 2 1145 (addi $1,$2,1145)
            e.g. lw 1 2 4 (lw $1,4($2))
            e.g. beq 1 2 -2 (beq $1,$2,-2)

        J-Type: OP offset (Imple: OP offset)
            e.g. j 64

        SP:     OP
            e.g. halt
                OP rs (Imple: OP rs 000...)
            e.g. jr 31 (jr $31)
                OP rs offset (Imple: OP rs 00000 offset)
            e.g. blez 12 -2 (blez $12,-2)
                OP rd rt sa (Imple: OP 00000 rt rd sa 000000)
            e.g. sll 2 3 1 (sll $2,$3,1)
*/
class Asm{
    public:
        Asm(){
            OP_Map={
                {"add","000000"},{"sub","000000"},{"slt","000000"},{"and","000000"},{"or","000000"},{"xor","000000"},{"addu","000000"},{"subu","000000"},{"sltu","000000"},
                {"addi","001011"},{"subi","001101"},{"slti","001111"},{"andi","010001"},{"ori","010010"},{"xori","010011"},{"addiu","001100"},{"subiu","001110"},{"sltiu","010000"},
                {"beq","000010"},{"bne","000011"},{"blez","000100"},{"sw","000101"},{"lw","000110"},{"j","000111"},{"jal","001000"},
                {"jr","001001"},{"sll","001010"},{"halt","111111"}
            };
            Funct_Map={
                {"add","000000"},{"sub","000010"},{"slt","000110"},{"and","001000"},{"or","001001"},{"xor","001010"},{"addu","000001"},{"subu","000011"},{"sltu","000111"}
            };
            Type_map={
                {"add",'R'},{"sub",'R'},{"slt",'R'},{"and",'R'},{"or",'R'},{"xor",'R'},{"addu",'R'},{"subu",'R'},{"sltu",'R'},
                {"addi",'I'},{"subi",'I'},{"slti",'I'},{"andi",'I'},{"ori",'I'},{"xori",'I'},{"addiu",'I'},{"subiu",'I'},{"sltiu",'I'},
                {"beq",'I'},{"bne",'I'},{"sw",'I'},{"lw",'I'},{"j",'J'},{"jal",'J'},
                {"jr",'S'},{"sll",'S'},{"blez",'S'},{"halt",'S'}
            };
        }
        void addAsmCode(string assembly){
            string opTemp; //存指令助记符
            string binaryCode; //最终得到的机器码
            stringstream ss;
            ss<<assembly;
            ss>>opTemp;
            //OP
            if(OP_Map.find(opTemp)!=OP_Map.end()){
                binaryCode+=OP_Map[opTemp];
            }
            else{
                throw "There's No Related Code!";
                return;
            }
            //After Process
            switch(Type_map[opTemp]){
                case 'R':{
                    string rd,rs,rt;
                    ss>>rd; ss>>rs; ss>>rt;
                    binaryCode+=decToBin(rs,5);
                    binaryCode+=decToBin(rt,5);
                    binaryCode+=decToBin(rd,5);
                    binaryCode+="00000";
                    binaryCode+=Funct_Map[opTemp];
                    break;
                }
                case 'I':{
                    string rt,rs,immi;
                    ss>>rt; ss>>rs; ss>>immi;
                    binaryCode+=decToBin(rs,5);
                    binaryCode+=decToBin(rt,5);
                    binaryCode+=decToBin(immi,16);
                    break;
                }
                case 'J':{
                    string offset;
                    ss>>offset;
                    binaryCode+=decToBin(offset,26);
                    break;
                }
                case 'S':{
                    if(opTemp=="jr"){
                        string rs;
                        ss>>rs;
                        binaryCode+=decToBin(rs,5);
                        binaryCode+="000000000000000000000"; // 21 0's
                    }
                    else if(opTemp=="sll"){
                        string rd,rt,sa;
                        ss>>rd; ss>>rt; ss>>sa;
                        binaryCode+="00000";
                        binaryCode+=decToBin(rt,5);
                        binaryCode+=decToBin(rd,5);
                        binaryCode+=decToBin(sa,5);
                        binaryCode+="000000";
                    }
                    else if(opTemp=="blez"){
                        string rs,offset;
                        ss>>rs>>offset;
                        binaryCode+=decToBin(rs,5);
                        binaryCode+="00000";
                        binaryCode+=decToBin(offset,16);
                    }
                    else if(opTemp=="halt"){
                        binaryCode+="00000000000000000000000000"; //26 0's
                    }
                    break;
                }
            }
            binary.push_back(binaryCode);
        }
        vector<string> getBinaryCode(){return binary;}
    private:
        //binary codes
        vector<string> binary;
        //OP Map
        map<string,string> OP_Map;
        //FUNCT Map
        map<string,string> Funct_Map;
        //Type Map
        map<string,char> Type_map;
        
        //dec to bin convert function
        string decToBin(string dec,int bit){
            int deci=stoi(dec);
            stack<bool> st;
            string ret;
            for(int i=0;i<bit;i++){
                st.push(deci%2);
                deci>>=1;
            }
            while(!st.empty()){
                ret+=to_string(st.top());
                st.pop();
            }
            return ret;
        }
};

template<typename T>
void printVec(vector<T>& vec,string& split){
    for(T& item:vec){
        cout<<item<<split;
    }
}
template<typename T>
void printVec(vector<T>& vec,const string split){
    for(T& item:vec){
        cout<<item<<split;
    }
}

int main(){
    Asm myAsm;
    while(1){
        char buffer[256]={0}; //我不信一行指令长度能超过256字节!
        cin.getline(buffer,256);
        string instrucion(buffer);
        if(instrucion=="-1") break;
        myAsm.addAsmCode(instrucion);
    }
    vector<string> bin(myAsm.getBinaryCode());
    printVec(bin,"\n");
    while(1) cin.get();
    return 0;
}