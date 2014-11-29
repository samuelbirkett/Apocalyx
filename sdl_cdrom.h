#ifndef SDL_CDROM_H
#define SDL_CDROM_H
#define SDL_MAX_TRACKS 99
#define SDL_AUDIO_TRACK 0x00
#define SDL_DATA_TRACK 0x04
typedef enum {
  CD_TRAYEMPTY,
  CD_STOPPED,
  CD_PLAYING,
  CD_PAUSED,
  CD_ERROR = -1
} CDstatus;
#define CD_INDRIVE(status)	((int)(status) > 0)
typedef struct SDL_CDtrack {
  unsigned char id;
  unsigned char type;
  unsigned short unused;
  unsigned int length;
  unsigned int offset;
} SDL_CDtrack;
typedef struct SDL_CD {
  int id;
  CDstatus status;
  int numtracks;
  int cur_track;
  int cur_frame;
  SDL_CDtrack track[SDL_MAX_TRACKS+1];
} SDL_CD;
int SDL_CDNumDrives(void);
const char *SDL_CDName(int drive);
SDL_CD* SDL_CDOpen(int drive);
CDstatus SDL_CDStatus(SDL_CD *cdrom);
int SDL_CDPlayTracks(SDL_CD *cdrom,
  int start_track, int start_frame, int ntracks, int nframes);
int SDL_CDPlay(SDL_CD *cdrom, int start, int length);
int SDL_CDPause(SDL_CD *cdrom);
int SDL_CDResume(SDL_CD *cdrom);
int SDL_CDStop(SDL_CD *cdrom);
int SDL_CDEject(SDL_CD *cdrom);
void SDL_CDClose(SDL_CD *cdrom);
#endif // SDL_CDROM_H
