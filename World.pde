public class World {
  
  float posX, posY; // the map moves based on player position
  
  final int totalTilesX;
  final int totalTilesY;
  final int mapWidth;
  final int mapHeight;
  final int tileWidth;
  final int tileHeight;
  final int viewportTileCount;
  
  final PImage tileSheet;
  PImage tileBlock;
  
  final int[][] mapData = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 5, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {3, 0, 0, 1, 3, 0, 0, 0, 0, 0, 0, 0, 4, 5, 9, 5, 6, 0, 0, 0, 0, 0, 0, 7, 0, 0, 8, 0, 0, 0, 0, 0, 4, 5, 5, 5, 5, 5, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {6, 0, 0, 4, 6, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 5, 6, 0, 0, 0, 0, 0, 0, 8, 0, 0, 8, 0, 0, 7, 0, 0, 4, 5, 5, 5, 9, 5, 5, 5, 2, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {6, 0, 0, 4, 6, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 5, 5, 2, 2, 2, 3, 0, 0, 8, 0, 0, 8, 0, 0, 8, 0, 0, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {5, 2, 2, 5, 6, 0, 0, 1, 2, 2, 2, 2, 5, 5, 5, 9, 5, 5, 5, 5, 6, 0, 0, 8, 0, 0, 8, 0, 0, 8, 0, 0, 4, 5, 5, 5, 5, 5, 5, 5, 9, 5, 6, 0, 0, 0, 0, 1, 2, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  };

  final int[][] mapLegend = {
    {}, // 0
    {0, 0}, // 1
    {60, 0}, // 2
    {120, 0}, // 3
    {0, 60}, // 4
    {60, 60}, // 5
    {120, 60}, // 6
    {180, 0}, // 7
    {180, 60}, // 8
    {240, 60} // 9
  };
  
  World (int w, int h) {
    tileSheet = loadImage("resources/world-tileset.png");
    tileWidth = w;
    tileHeight = h;
    totalTilesX = mapData[0].length;
    totalTilesY = mapData.length;
    mapWidth = tileWidth * totalTilesX;
    mapHeight = tileHeight * totalTilesY;
    viewportTileCount = globals.viewportWidth / tileWidth;
  }
  
  void init () {
    posX = posY = 0;
  }
  
  void reset () {
    init();
  }
  
  void redraw () {
    
    float playerCenter = player.posX + (player.sizeWidth / 2);
    int mapThresholdRight = mapWidth - globals.viewportHalfWidth;
    int mapThresholdLeft = globals.viewportHalfWidth;
    
    // player has moved past the map width minus half the viewport
    if (playerCenter > mapThresholdRight) {
      posX = (mapWidth - globals.viewportWidth) * -1;
    // player has moved past the middle of the viewport
    } else if (playerCenter > mapThresholdLeft) {
      posX = (playerCenter - mapThresholdLeft) * -1;
    } else {
      posX = 0;
    }
    
    applet.translate(posX, posY);

    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) { 
        int tileType = mapData[y][x];
        if (tileType > 0 && isDrawable(x, 1)) {
          tileBlock = tileSheet.get(mapLegend[tileType][0], mapLegend[tileType][1], tileWidth, tileHeight);
          image(tileBlock, x * tileWidth, y * tileHeight, tileWidth, tileHeight);
        }
        //noFill();
        //stroke(0);
        //rect(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
      }
    }
    
  }
  
  boolean isWalkable (int tileX, int tileY) {
    // prevent access to array when out of bounds     
    if (tileX < 0 || tileX >= totalTilesX || tileY < 0 || tileY >= totalTilesY) return false;
    else if (mapData[tileY][tileX] == 0) return true;
    else return false;
  }
  
  boolean isDrawable (int tileX, int offsetX) {
    // note: offsetX is subject to change depending on what is calling this method (DUH!)
    // for example: ~ tiles only require 1 block of offset to completely hide them when not within the viewport
    //              ~ but interactive objects require 2 blocks of offset for objects wider than 1 tile, such as trees
    int baseTile = floor(abs(posX) / tileWidth);
    return tileX > (baseTile - offsetX) && tileX < (baseTile + viewportTileCount + offsetX);
  }

  int[] getTileByCoords (float coordX, float coordY) {
    int[] tile = new int[2];
    tile[0] = floor(coordX / tileWidth);
    tile[1] = floor(coordY / tileHeight);
    return tile;
  }

}