/*
 * Hello world example
 */
#include <rtems.h>
#include <rtems/test.h>
#include <rtems/test-info.h>
#include <stdlib.h>
#include <buffer_test_io.h>
#include <stdio.h>

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

const char rtems_test_name[] = "HELLO TEST";
const char hello_world[] = "Hello World";


rtems_task Init(
  rtems_task_argument ignored
)
{
  (void) ignored; 
  TEST_BEGIN();
  const volatile int init_k = 100;
  printf( "\n%s: %d\n", hello_world, init_k );
  TEST_END();
  exit( 0 );
}