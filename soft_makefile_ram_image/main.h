// function to wait or write on console
void tempo(int temps);
int puts(const char *string);
int putchar(int value);

// choose your chara
void perso(int a, int b);

// draw aliens or spaceship from their coordonates
void VGA_SPRITE_Alien(int x, int y);
void VGA_SPRITE_Vaisseau(int x);

// equal 1 if you press the button, 0 else
int BTN_R(void);
int BTN_L(void);
int BTN_U(void);

//7 seg for score
void SEG7b(int E4, int E3, int E2, int E1);

// tables with 0 or 1 depending if aliens or lasers are alive send by gpio
void alien_alive(int* t);
void laser_on(int* t);

// init at the begginig, caracters comming
int init_vaisseau(int x);
void init_alien(int x,int y, int* t);

// tiny animmation for the alien while waiting they are kill
int move_alien(int x, int y);

// the lasers
void laser_1(int x, int y);
void laser_2(int x, int y);
void laser_3(int x, int y);

// draw all : alived aliens and spaceship with lasers
//void draw(int x1,int y1,int x2,int* a, int*l, int xl1, int yl1, int xl2, int yl2, int xl3, int yl3, int c);

