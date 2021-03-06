package com.project.hunsu.repository;

import com.project.hunsu.model.entity.User;
import com.project.hunsu.model.entity.WearReply;
import com.project.hunsu.model.entity.WearReplyLike;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface WearReplyLikeRepository extends JpaRepository<WearReplyLike,Long> {
    WearReplyLike findReplyLikeByReplyAndUser(WearReply reply, User user);
    List<WearReplyLike> findReplyLikeByUser(User user);

}
