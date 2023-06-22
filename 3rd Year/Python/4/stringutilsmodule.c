#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <ctype.h>

static PyObject *stringError;

static PyObject * stringutils_unique(PyObject *self, PyObject *args) {
    const char *string;

    if (!PyArg_ParseTuple(args, "s", &string)) {
        return NULL;
    }
    
    //To support non ascii (unicode), the array should be about 65000+ in size.
    int char_count[256] = {0}; 

    for (size_t i = 0; i < strlen(string); i++) {
        int char_index = (int)string[i]; 

        if (!isascii(char_index)) {
            // NON-ascii is not supported
            PyErr_SetString(stringError, "Non Ascii values are not supported");
            return NULL;
        }

        char_count[char_index]++; 

        if (char_count[char_index] > 1) {
            Py_RETURN_FALSE;
        }
    }

    Py_RETURN_TRUE;
}

static PyMethodDef stringutilsMethods[] = {
    {"unique", stringutils_unique, METH_VARARGS, "Check if symbols are unique"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef stringutilsModule = {
    PyModuleDef_HEAD_INIT,
    "stringutils",
    "Various string utilities",
    -1,
    stringutilsMethods
};

PyMODINIT_FUNC
PyInit_stringutils(void) 
{
    PyObject *m;
    m = PyModule_Create(&stringutilsModule);
    if (m == NULL) 
        return NULL;
    
    stringError = PyErr_NewException("stringutils.error", NULL, NULL);
    Py_XINCREF(stringError);
    if (PyModule_AddObject(m, "error", stringError) < 0) {
        Py_XDECREF(stringError);
        Py_CLEAR(stringError);
        Py_DECREF(m);
        return NULL;
    }
    return m;
}

