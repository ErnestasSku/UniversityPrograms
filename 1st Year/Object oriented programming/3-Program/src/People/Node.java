package People;

import javafx.scene.input.MouseEvent;

public interface Node {
    public int[] getPos();
    void mouseClickTreeItem(MouseEvent event);
}