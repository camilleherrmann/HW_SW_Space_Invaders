#include "main.h"

int main()
{

	// initialization var
	int x_v = 0;   // x of the spaceship
	int y_a = 0;	// y of the aliens
	int x_a = 0;	// x of the aliens
	int v[26];		// table that contains 1 if the alien is alive
	int w = 50; 
    int dx = 39; 
	int dy = 15;
	int laseron[3];
	int x_las1 = 0;
	int x_las2 = 0;
	int x_las3 = 0;
	int y_las1 = 0;
	int y_las2 = 0;
	int y_las3 = 0;
	int cpt =0;
	int tmp = 27;
	int loose = 0;
	int i,j;
	int t = 0;
	

	while(1)
	{
		if (BTN_L() || BTN_R())
		{
			// choose your character
			if (BTN_L()) {perso(0,1);}
			if (BTN_R()) {perso(1,0);}
			tempo(20);
			// fill the tables of 0
			for (i=0; i<3; i++)
			{
				laseron[i] = 0;
			}
			v[0] = 0;
			for (i=1; i<=25; i++)
			{
				v[i]=0;
			}
			init_alien(x_a, y_a,v);
			x_v = init_vaisseau(x_v);
		
			while(loose == 0)
			{
				puts(".");
				// moves of spaceship with L and R 
				if (BTN_L() && x_v > 0)
					{ x_v = x_v - 5;
					VGA_SPRITE_Vaisseau(x_v);
					}
				if (BTN_R())
					{ x_v = x_v + 5;
					VGA_SPRITE_Vaisseau(x_v);
					}

				// laserrrrrrrrr
				if (BTN_U())
				{	
					if (laseron[0]==0)
					{
					laseron[0] = 1;
					x_las1 = x_v + 35;
					y_las1 = 400;
					laser_on(laseron);
					laser_1(x_las1,y_las1);
					tempo(10);
					}

					
					else if (laseron[1]==0)
					{
					laseron[1] = 1;
					x_las2= x_v + 35;
					y_las2 = 400;
					laser_on(laseron);
					laser_2(x_las2,y_las2);
					tempo(10);
					}

					else if (laseron[2]==0)
					{
					laseron[2] = 1;
					x_las3 = x_v + 35;
					y_las3 = 400;
					laser_on(laseron);
					laser_3(x_las3,y_las3);
					tempo(10);
					}
				}

				if (laseron[0]==1) {if (y_las1 == 0)
									{
										laseron[0] = 0;
										laser_on(laseron);
									}
									else y_las1 = y_las1 - 8;
									laser_1(x_las1,y_las1);
									}

				if (laseron[1]==1) {if (y_las2 == 0)
									{
										laseron[1] = 0;
										laser_on(laseron);
									}
									else y_las2 = y_las2 - 8;
									laser_2(x_las2,y_las2);
									}
				if (laseron[2]==1) {if (y_las3 == 0)
									{
										laseron[2] = 0;
										laser_on(laseron);
									}
									else y_las3 = y_las3 - 8;
									laser_3(x_las3,y_las3);
									}

			// aliens touched 
				for (i=1; i<6; i++ )
				{
					for (j=1; j<6; j++)
					{
						if (x_las1 >= x_a + (2*j-1)*dx + (j-1)*w 
							&& x_las1 + 4  <= x_a + (2*j-1)*dx + (j)*w 
							&& y_las1 - 20 < y_a +(2*i-1)*dy + (i-1)*w 
							&& laseron[0] == 1
							&& v[5*(i-1) + j] == 1)	
						
						{
							v[5*(i-1) + j] = 0;
							alien_alive(v);
							laseron[0] = 0;
							laser_on(laseron);
							cpt = cpt + 1;
							SEG7b(0,0,(cpt-cpt%10)/10, cpt%10);
						}
				
						if (x_las2 >= x_a + (2*j-1)*dx + (j-1)*w 
							&& x_las2 + 4  <= x_a + (2*j-1)*dx + (j)*w 
							&& y_las2 - 20 < y_a +(2*i-1)*dy + (i-1)*w 
							&& laseron[1] == 1
							&& v[5*(i-1) + j] == 1)	
						{
							v[5*(i-1) + j] = 0;
							alien_alive(v);
							laseron[1] = 0;
							laser_on(laseron);
							cpt = cpt + 1;
							SEG7b(0,0,(cpt-cpt%10)/10, cpt%10);
						}

						if (x_las3 >= x_a + (2*j-1)*dx + (j-1)*w 
							&& x_las3 + 4  <= x_a + (2*j-1)*dx + (j)*w 
							&& y_las3 - 20 < y_a +(2*i-1)*dy + (i-1)*w 
							&& laseron[2] == 1
							&& v[5*(i-1) + j] == 1)
						{
							v[5*(i-1) + j] = 0;
							alien_alive(v);
							laseron[2] = 0;
							laser_on(laseron);
							cpt = cpt + 1;
							SEG7b(0,0,(cpt-cpt%10)/10, cpt%10);
						}
					}
				}
				
				// aliens move
				if (t%200 == 0 && tmp>6) {tmp = tmp - 6;}

				if (t%tmp == 0)  {y_a = y_a + 5;}	

				if (y_a == 80)   // in case round reach the bottom
				{
					for(j = 25; j>20; j--)
					{
						loose = loose + v[j];
						putchar(48+loose);
					}
					for (i = 25; i>=6; i--)
					{
						v[i] = v[i-5];
					}

					for (i = 1; i<=5; i++)
					{
						v[i]=1;
					}
					y_a = y_a - 80;
				}
				alien_alive(v);
				VGA_SPRITE_Alien(x_a, y_a);
				t=t+1;
				tempo(10);  // here we go again 
			}
		perso(1,1);
		tempo(400);
		t=0;
		tmp =27;
		cpt = 0;
		loose = 0;
		perso(0,0);		
		}
	}
}


void tempo(int temps)
{
	int t=0;
	for(t=0; t< temps*100000; t++)
	{ t= t +1 ; }
}

void init_alien(int x,int y,int* t)
{
	int i;
	for (i=1; i<6; i++)
	{
		t[i]=1;
	}
	alien_alive(t);
	VGA_SPRITE_Alien(x, y);
	tempo(50);

	for (i=7; i<10; i++)
	{
		t[i]=1;
	}
	alien_alive(t);
	VGA_SPRITE_Alien(x, y);
	tempo(50);

	t[13]=1;
	alien_alive(t);
	VGA_SPRITE_Alien(x, y);
	tempo(30);
	
}

int init_vaisseau(int x)
{
	while (x < 280)
	{
		x = x + 10;
		VGA_SPRITE_Vaisseau(x);
		tempo(20);
	}
	return x;
}






