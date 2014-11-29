#ifndef SDL_JOYSTICK_H
#define SDL_JOYSTICK_H
struct _SDL_Joystick;
typedef struct _SDL_Joystick SDL_Joystick;
int SDL_NumJoysticks(void);
const char * SDL_JoystickName(int device_index);
SDL_Joystick * SDL_JoystickOpen(int device_index);
int SDL_JoystickOpened(int device_index);
int SDL_JoystickIndex(SDL_Joystick *joystick);
int SDL_JoystickNumAxes(SDL_Joystick *joystick);
int SDL_JoystickNumBalls(SDL_Joystick *joystick);
int SDL_JoystickNumHats(SDL_Joystick *joystick);
int SDL_JoystickNumButtons(SDL_Joystick *joystick);
void SDL_JoystickUpdate(void);
int SDL_JoystickEventState(int state);
short SDL_JoystickGetAxis(SDL_Joystick *joystick, int axis);
#define SDL_HAT_CENTERED 0x00
#define SDL_HAT_UP 0x01
#define SDL_HAT_RIGHT 0x02
#define SDL_HAT_DOWN 0x04
#define SDL_HAT_LEFT 0x08
#define SDL_HAT_RIGHTUP (SDL_HAT_RIGHT|SDL_HAT_UP)
#define SDL_HAT_RIGHTDOWN (SDL_HAT_RIGHT|SDL_HAT_DOWN)
#define SDL_HAT_LEFTUP (SDL_HAT_LEFT|SDL_HAT_UP)
#define SDL_HAT_LEFTDOWN (SDL_HAT_LEFT|SDL_HAT_DOWN)
unsigned char SDL_JoystickGetHat(SDL_Joystick *joystick, int hat);
int SDL_JoystickGetBall(SDL_Joystick *joystick, int ball, int *dx, int *dy);
unsigned char SDL_JoystickGetButton(SDL_Joystick *joystick, int button);
void SDL_JoystickClose(SDL_Joystick *joystick);
#endif // SDL_JOYSTICK_H
