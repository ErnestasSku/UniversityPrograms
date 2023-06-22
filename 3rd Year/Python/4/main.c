#define PY_SSIZE_T_CLEAN
#include <Python.h>

void check_error(PyObject *test) {
    if (!test) {
        PyErr_Print();
        exit(1);
    }
}

int main() {
    PyObject *pName, *pModule, *pSegment;

    Py_Initialize();

    PyRun_SimpleString("import sys");
    PyRun_SimpleString("sys.path.append(\".\")");

    pName = PyUnicode_DecodeFSDefault("points");
    pModule = PyImport_Import(pName);

    Py_DECREF(pName);

    if (pModule != NULL) {
        pSegment = PyObject_GetAttrString(pModule, "Segment");
        check_error(pSegment);

        PyObject *segmentTupleArgs = PyTuple_New(2);
        // PyTuple_SetItem(segmentTupleArgs, 0, PyLong_FromLong(3));
        // PyTuple_SetItem(segmentTupleArgs, 1, PyLong_FromLong(14));
        PyTuple_SetItem(segmentTupleArgs, 0, PyFloat_FromDouble(3.5));
        PyTuple_SetItem(segmentTupleArgs, 1, PyFloat_FromDouble(12.9));
        PyObject *segmentObj = PyObject_CallObject(pSegment, segmentTupleArgs);
        check_error(segmentObj);

        PyObject *result = PyObject_CallMethod(segmentObj, "length", NULL);
        check_error(result);

        // int length = PyLong_AsLong(result);
        double length = PyFloat_AsDouble(result);
        Py_DECREF(result);

        printf("The length of the segment is %f.\n", length);


        Py_DECREF(pSegment);
        Py_DECREF(pModule);
    }

    Py_Finalize();

    return 0;
}

