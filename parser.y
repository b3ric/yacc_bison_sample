%{
#include "audio_controller.h"

int yylex();
int yyparse();

void yyerror(const char *str){fprintf(stderr,"error: %s\n",str);}

int yywrap(){return 1;}
%}
%union
{
        int number;
        char* string;
}

%token ADD STATUS INCREASE DECREASE TURN QUIT SET
%token <number> NUMBER
%token <string> ROOM
%token <string> ONOFF

%%
commands: /* epsilon rule */
        | commands command
	| commands error
        ;
command:
        add_room
	| get_room_status
	| turn_off_on
	| quit
	| set_volume
	| increase_volume
	| decrease_volume
        ;
add_room:
        ADD ROOM
        {
                strcpy(room_list[current_room_index].name, $2);
		room_list[current_room_index].volume = 10;
		strcpy(room_list[current_room_index].on_off, "off");
		current_room_index = current_room_index + 1;
		printf("\t'%s' added!\n",$2);
        }
        ;
get_room_status:
        STATUS ROOM
        {
                find_room_data($2);
        }
	;
increase_volume:
	INCREASE ROOM
	{
		increase_room_volume($2);
	}
	;
decrease_volume:
	DECREASE ROOM
	{
		decrease_room_volume($2);
	}
	;
turn_off_on:
	TURN ROOM ONOFF
	{
		set_room_status($2, $3);
	}
	;
quit:
	QUIT
	{
		exit(0);
	}
	;
set_volume:
	SET ROOM NUMBER
	{
		 if(set_room_volume($2, $3) == 1)
                {
                        printf("\t'%s' is set to '%d'\n", $2, $3);
                }
                else
                {
                        printf("\t'did not find %s'\n", $2);
                }
	}
	;
%%
