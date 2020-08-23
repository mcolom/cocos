type wordPtr = ^word;
     bytePtr = ^byte;

var
  puntero_ima   : pointer;
  tierra_ptr    : pointer;      { punteros a los sprites }
  coco_ptr      : pointer;
  bloque_ptr    : pointer;
  superc_ptr    : pointer;
  calav_ptr     : pointer;
  vida_ptr      : pointer;
  interrog_ptr  : pointer;
  comecocos_ptr : array[0..3,0..5] of pointer;
  fan_ptr       : array[0..5] of pointer;
  fan_nor_ptr       : array[0..5] of pointer;
  fan_as_ptr       : array[0..5] of pointer;
  vidas_ptr     : pointer;

  comecocos_spr : pointer;
  casillas_spr  : pointer;

  punto_ptr     : pointer;

  mapa_ptr      : pointer;  { mapa del tablero }
  segm_mapa,offs_mapa : word;
  paleta : array[0..800] of byte;

    { variables del juego }
    cocos                 : word;     { n£mero de cocos en el mapa }
    tamano_x              : byte;
    tamano_y              : byte;
    bloque_x_max          : byte;
    bloque_y_max          : byte;
    come_x                : integer;
    come_y                : integer;
    fantasmas             : byte;
    x : word;              { coordenadas iniciales del ... }
    y : word;              { ... comecocos }
    hori , vert: shortint;  { movimiento autom tico del comecocos }
    come_ani : byte; { fotograma del comecocos [0,5] }
    come_dir : byte; { direcci¢n en la que se mueve el comecocos [0,3] }
    nivel : byte; { nivel actual }
    vidas : byte;
    juego_acabado : boolean;
    guarda_x , guarda_y : word;
    timer_toxico : integer;
    timer_scoco : integer;
    inmune : boolean;
    intoxicado : boolean;
    bloques_en_mem : byte;  { bloques actualmente en memoria }


 { variables de los fantasmas }
 fan_x : array[0..100] of integer;
 fan_y : array[0..100] of integer;
 fan_dir : array[0..100] of byte;
 fan_falta : array[0..100] of shortint;

 { control de luz }
 paleta_luz : array[0..800] of byte;

 { teclas de control }
 tecla_der , tecla_izq , tecla_arr , tecla_aba : char;
 tecla_der_ori,tecla_izq_ori,tecla_arr_ori,tecla_aba_ori : char;

 salir : boolean;

 { mensajes }
 var
  over_ptr : pointer;
  deno_ptr : pointer;
  arriba_ptr : pointer;
  abajo_ptr : pointer;
  izq_ptr : pointer;
  derecha_ptr : pointer;

 const velocidad : byte = 2;        { velocidad del comecocos (scroll) }
       velocidad_fan : byte = 1;    { velocidad de los fantasmas }
       x_come_const = 140; { 20 * 7 }
       y_come_const = 100; { 25 * 4 }
       pantallas = 60;

var mi_integer : integer;
