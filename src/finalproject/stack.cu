#include <stdio.h>
#include <stdlib.h>
#include "stack.h"

void stack_init(Stack* s, int size) {
    s->size = size;
    s->array = (int*)malloc(size * sizeof(int));
    s->top = 0;
}

int pop(Stack* s) {
  if(!is_empty(s)) {
    return s->array[s->top--];
  }
  return -1;
}

int push(Stack* s,int element) {
  if(s->top != s->size-1)
    return -1;
  return (s->array[++s->top] = element);
}

void destroy(Stack* s) {
  free(s->array);
}

int is_empty(Stack* s) {
  return s->top == 0;
}