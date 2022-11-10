#include "plasma.h"

#define MemoryRead(A) (*(volatile unsigned int*)(A))
#define MemoryWrite(A,V) *(volatile unsigned int*)(A)=(V)

int putchar(int value)
{
   while((MemoryRead(IRQ_STATUS) & IRQ_UART_WRITE_AVAILABLE) == 0);
   MemoryWrite(UART_WRITE, value);
   return 0;
}

int puts(const char *string)
{
   while(*string)
   {
      if(*string == '\n')
         putchar('\r');
      putchar(*string++);
   }
   return 0;
}

void print_hex(unsigned long num)
{
   long i;
   unsigned long j;
   for(i = 28; i >= 0; i -= 4) 
   {
      j = (num >> i) & 0xf;
      if(j < 10) 
         putchar('0' + j);
      else 
         putchar('a' - 10 + j);
   }
}

void OS_InterruptServiceRoutine(unsigned int status)
{
   (void)status;
   putchar('I');
}

int kbhit(void)
{
   return MemoryRead(IRQ_STATUS) & IRQ_UART_READ_AVAILABLE;
}

int getch(void)
{
   while(!kbhit()) ;
   return MemoryRead(UART_READ);
}
/*
void Led(int value)
{
	MemoryWrite(GPIO0_CLEAR, (~value) & 0xffff); //clear
	MemoryWrite(GPIO0_OUT, value);  //Change LEDs
}

int SW(void)
{
	int x =  MemoryRead(GPIOA_IN);
	return (x & 0xffff);
}*/

int BTN_L(void)
{
	int x = MemoryRead(GPIOA_IN);
	return (x & 0x80000);
}	

int BTN_R(void)
{
	int x = MemoryRead(GPIOA_IN);
	return (x & 0x40000);
}

int BTN_U(void)
{
	int x = MemoryRead(GPIOA_IN);
	return (x & 0x20000);
}	

int BTN_D(void)
{
	int x = MemoryRead(GPIOA_IN);
	return (x & 0x10000);
}


void SEG7b(int E4, int E3, int E2, int E1) {
	//ALIGNEMENT DES PARAMETRES PAR DECALAGE A GAUCHE DE X BITS
	int tmp=(E4<<0) | (E3<<8) | (E2<<16) | (E1<<24);
	MemoryWrite(GPIO1_CLEAR, (~tmp) & 0xffff0000); //clear
	MemoryWrite(GPIO1_OUT, tmp); //set
} 

void perso(int a, int b)
{
int tmp= (a<<28) | ( b<< 29);
	MemoryWrite(GPIO3_CLEAR, (~tmp) & 0x30000000); //clear
	MemoryWrite(GPIO3_OUT, tmp); //set
}

void VGA_SPRITE_Alien(int x, int y) {
	int tmp=(x<<0) | (y<<10);
	MemoryWrite(GPIO2_CLEAR, (~tmp) & 0xfffff); //clear
	MemoryWrite(GPIO2_OUT, tmp); //set
} 

void VGA_SPRITE_Vaisseau(int x) {
	int tmp=(x<<20);
	MemoryWrite(GPIO2_CLEAR, (~tmp) & 0x3ff00000); //clear
	MemoryWrite(GPIO2_OUT, tmp); //set
} 

void alien_alive(int* t)
{
	int tmp = t[1]<<0 | (t[2] << 1) | (t[3] << 2) | (t[4] << 3) | (t[5] << 4) |
				(t[6]<<5) | (t[7] << 6) | (t[8] << 7) | (t[9] << 8)| (t[10] << 9) |
				(t[11]<<10) | (t[12] << 11) | (t[13] << 12) | (t[14] << 13)| (t[15] << 14) |
				(t[16]<<15) | (t[17] << 16) | (t[18] << 17) | (t[19] << 18)| (t[20] << 19) |
				(t[21]<<20) | (t[22] << 21) | (t[23] <<22) | (t[24] << 23)| (t[25] << 24);

	MemoryWrite(GPIO3_CLEAR, (~tmp) & 0x01ffffff); //clear
	MemoryWrite(GPIO3_OUT, tmp); //set
}


void laser_on(int* t)
{
	int tmp= (t[0] <<25) | ( t[1]<< 26) | (t[2] << 27);
	MemoryWrite(GPIO3_CLEAR, (~tmp) & 0x0e000000); //clear
	MemoryWrite(GPIO3_OUT, tmp); //set
}

void laser_1(int x, int y)
{
	MemoryWrite(GPIO4_CLEAR, (~x) & 0x000003ff); //clear
	MemoryWrite(GPIO4_OUT, x); //set
	MemoryWrite(GPIO0_CLEAR, (~y) & 0x000003ff); //clear
	MemoryWrite(GPIO0_OUT, y); //set
}

void laser_2(int x, int y)
{
	x=(x<<10);
	y =(y<<10);
	MemoryWrite(GPIO4_CLEAR, (~x) & 0x000ffc00); //clear
	MemoryWrite(GPIO4_OUT, x); //set
	MemoryWrite(GPIO0_CLEAR, (~y) & 0x000ffc00); //clear
	MemoryWrite(GPIO0_OUT, y); //set
}

void laser_3(int x, int y)
{
	x=(x<<20);
	y =(y<<20);
	MemoryWrite(GPIO4_CLEAR, (~x) & 0x3ff00000); //clear
	MemoryWrite(GPIO4_OUT, x); //set
	MemoryWrite(GPIO0_CLEAR, (~y) & 0x3ff00000); //clear
	MemoryWrite(GPIO0_OUT, y); //set
}

