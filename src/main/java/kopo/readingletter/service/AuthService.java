package kopo.readingletter.service;

import kopo.readingletter.dto.UserDTO;
import kopo.readingletter.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserMapper userMapper;
    private final BCryptPasswordEncoder encoder;

    public void signup(String email, String password, String nickname) {
        if (userMapper.findByEmail(email) != null) {
            throw new IllegalArgumentException("이미 가입된 이메일");
        }
        UserDTO dto = new UserDTO();
        dto.setEmail(email);
        dto.setPassword(encoder.encode(password));
        dto.setNickname(nickname);

        userMapper.insertUser(dto);
    }

    public UserDTO login(String email, String password) {
        UserDTO user = userMapper.findByEmail(email);
        if (user == null) return null;
        if (!encoder.matches(password, user.getPassword())) return null;
        return user;
    }
}
