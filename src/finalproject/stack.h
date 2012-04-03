/**
 * Yuri Gorokhov
 * Stack method declarations
 */

#ifndef _STACK_H_
#define _STACK_H_

typedef struct {
  int * array;
  int top;
  int size;
} Stack;

void stack_init(Stack*, int);
int pop(Stack*);
int push(Stack*,int);
void destroy(Stack*);
int is_empty(Stack*);

#endif