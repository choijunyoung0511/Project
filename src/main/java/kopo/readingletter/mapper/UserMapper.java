package kopo.readingletter.mapper;

import kopo.readingletter.dto.UserDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {
    UserDTO findByEmail(String email);
    int insertUser(UserDTO dto);
}
