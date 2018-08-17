#ifndef BKGIMGPROVIDER_H
#define BKGIMGPROVIDER_H

#include <QQuickImageProvider>

class BkgImgProvider : public QQuickImageProvider
{
public:
    explicit BkgImgProvider();
    virtual QImage requestImage(const QString &id, QSize *size, const QSize& requestedSize);
    virtual QPixmap requestPixmap(const QString &id, QSize *size, const QSize& requestedSize);

signals:

public slots:
};

#endif // BKGIMGPROVIDER_H
