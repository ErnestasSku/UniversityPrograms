import pandas as pd
import matplotlib.pyplot as plt


def show_table(data, columns=list('lrff'), cols=None): 
    fig, ax = plt.subplots()

    fig.patch.set_visible(False)
    ax.axis('off')
    ax.axis('tight')

    
    df = pd.DataFrame(data, columns=columns)
    pd.set_option("display.precision", 10)

    print(df.to_latex())

    ax.table(cellText=df.values, loc='center', colLabels=columns, colWidths=cols)
    
    fig.tight_layout()
    plt.show()
