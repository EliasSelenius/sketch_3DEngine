

start:props

end:props



start:vert

    uniform mat4 transform;
    uniform mat4 texMatrix;

    attribute vec4 position;
    attribute vec4 color;
    attribute vec2 texCoord;

    varying vec4 vertColor;
    varying vec4 vertTexCoord;

    void main() {
        gl_Position = transform * position;
        
        vertColor = color;
        vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
    }

end:vert



start:frag

    uniform sampler2D texture;

    varying vec4 vertColor;
    varying vec4 vertTexCoord;

    void main() {
        vertColor = vec4(1, 1, .3, 1);
        gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor;
    }
    
end:frag






