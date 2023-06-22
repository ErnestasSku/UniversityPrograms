package usecases;

import java.util.List;

public interface JobAssigner {
    int assignJob(int workId, List<Integer> orderList, List<Integer> workerOrders);
}
